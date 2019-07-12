class StockHoldsController < ApplicationController
  before_action :set_stock_hold, only: [:show, :edit, :update, :destroy]
  before_action :sign_in_required

  # 一覧
  def index
    #パラメーター取得
    @p_list=params[:p_list]

    #ページタイトル設定
    @title = set_stock_hold_name(@p_list)

    #保有銘柄、銘柄情報、銘柄情報から算出した現在値の損益
    #Ransack検索キー
    @q = StockHold.ransack(params[:q])
    @stock_holds =@q.result.joins("Inner JOIN users on users.id=stock_holds.user_id")
                       .joins("LEFT JOIN stock_infos ON stock_infos.stock_code = stock_holds.stock_code")
                       .joins("INNER JOIN system_codes ON stock_holds.stock_type = system_codes.key and opt = '003'")
                       .joins("INNER JOIN banks ON stock_holds.bank_id = banks.id and stock_holds.user_id = banks.user_id")
                       .joins("INNER JOIN system_codes as bank_opt on banks.opt = bank_opt.key and bank_opt.opt = '006'")
                       .where("users.id = ?" ,current_user.id )
                       .select("banks.id as bank_id,banks.expire_flg,bank_opt.name as bank_opt_name,banks.year,banks.name,banks.opt,stock_holds.*,stock_infos.stock_name stock_code_name,stock_infos.end_rate_mny,(stock_holds.buy_quantity * COALESCE(stock_infos.end_rate_mny, 0) - stock_holds.buy_quantity * stock_holds.buy_rate_mny - COALESCE(stock_holds.expenses_mny, 0)) as profit_loss_current,system_codes.name as stock_type_name")

    #表示条件毎の取得条件設定
    case @p_list
      when Settings.stock_holds_list.year then #年度別
        @stock_holds = @stock_holds.where("sell_quantity is null").order(    "year desc","opt","bank_opt_name","banks.name","stock_code","buy_date","created_at")
      when Settings.stock_holds_list.profit_loss_year then
        @stock_holds = @stock_holds.where("sell_quantity is not null").order("year desc","opt","bank_opt_name","banks.name","stock_code","buy_date","created_at")
      when Settings.stock_holds_list.stock then #銘柄別
        @stock_holds = @stock_holds.where("sell_quantity is null").order(    "stock_code","year desc","opt","bank_opt_name","banks.name","buy_date","created_at")
      when Settings.stock_holds_list.profit_loss_stock then
        @stock_holds = @stock_holds.where("sell_quantity is not null").order("stock_code","year desc","opt","bank_opt_name","banks.name","buy_date","created_at")
      when Settings.stock_holds_list.bank then #口座別
        @stock_holds = @stock_holds.where("sell_quantity is null").order(    "banks.name","opt","bank_opt_name","year desc","stock_code","buy_date","created_at")
      when Settings.stock_holds_list.profit_loss_bank then
        @stock_holds = @stock_holds.where("sell_quantity is not null").order("banks.name","opt","bank_opt_name","year desc","stock_code","buy_date","created_at")
      when Settings.stock_holds_list.profit_current then #保有 利益順
        @stock_holds = @stock_holds.where("sell_quantity is null").where("    (stock_holds.buy_quantity * COALESCE(stock_infos.end_rate_mny, 0) - stock_holds.buy_quantity * stock_holds.buy_rate_mny - COALESCE(stock_holds.expenses_mny, 0)) >=0 and stock_type = 'jpn_stock' ").order("profit_loss_current desc","opt","year desc","bank_opt_name","banks.name","stock_code","buy_date","created_at")
      when Settings.stock_holds_list.loss_current then   #保有 損失順
        @stock_holds = @stock_holds.where("sell_quantity is null").where(    "(stock_holds.buy_quantity * COALESCE(stock_infos.end_rate_mny, 0) - stock_holds.buy_quantity * stock_holds.buy_rate_mny - COALESCE(stock_holds.expenses_mny, 0)) <= 0 and stock_type = 'jpn_stock'").order("profit_loss_current asc ","opt","year desc","bank_opt_name","banks.name","stock_code","buy_date","created_at")
      when Settings.stock_holds_list.profit_loss_profit then
        @stock_holds = @stock_holds.where("sell_quantity is not null").where("(stock_holds.sell_quantity * COALESCE(stock_holds.sell_rate_mny, 0) - stock_holds.buy_quantity * stock_holds.buy_rate_mny - COALESCE(stock_holds.expenses_mny, 0)) >=0").order(                            "profit_loss_mny desc ","opt","year desc","bank_opt_name","banks.name","stock_code","buy_date","created_at")
      when Settings.stock_holds_list.profit_loss_loss then
        @stock_holds = @stock_holds.where("sell_quantity is not null").where("(stock_holds.sell_quantity * COALESCE(stock_holds.sell_rate_mny, 0) - stock_holds.buy_quantity * stock_holds.buy_rate_mny - COALESCE(stock_holds.expenses_mny, 0)) <=0").order(                            "profit_loss_mny asc ","opt","year desc","bank_opt_name","banks.name","stock_code","buy_date","created_at")
    end

    #NISA口座の有効期限ぎれの有無をチェックし、アラート表示
    if Bank.joins("INNER JOIN stock_holds ON stock_holds.bank_id = banks.id and stock_holds.user_id = banks.user_id")
           .where("banks.user_id = "  + current_user.id.to_s + " and banks.opt in(1,2) and expire_flg = true and stock_holds.sell_quantity is null").records.count >0
      flash[:notice] = "NISA口座の保有銘柄の中に、NISAの有効期間切れの登録銘柄があります。<br>NISAの有効期間内に譲渡するか、口座種類をNISA口座、ジュニアNISAから一般口座、特定口座に変更ください。".html_safe
    end

    #ページング
    @stock_holds = @stock_holds.page(params[:page]).per(5)

  end

  def show
    @p_list = params[:p_list]

    #株式分類取得
    @stock_type_name=SystemCode.find_by(opt: '003', key: @stock_hold.stock_type).name

    #一部譲渡の場合、flash領域の譲渡後の保有残を表示領域に設定
    if !flash[:stock_hold2].nil?
      @stock_hold2 = flash[:stock_hold2]
      @stock_hold2["stock_type"]=SystemCode.find_by(opt: '003', key: @stock_hold2["stock_type"]).name
    end
  end

  def new
    @p_list = params[:p_list]
    @stock_hold = StockHold.new

    #銘柄検索から保有銘柄登録で遷移してきた場合、銘柄コードを設定
    if !flash[:stock_code].nil?
      @stock_hold.stock_code=flash[:stock_code]
    end

    #口座管理から保有銘柄登録で遷移してきた場合、口座IDを設定
    if !flash[:bank_id].nil?
      @stock_hold.bank_id=flash[:bank_id]
    end
  end

  def edit
    @p_list = params[:p_list]

  end

  def create
    @p_list = params[:p_list]

    #譲渡の場合、譲渡損益を算出
    if params[:stock_hold][:sell_rate_mny].to_s!="" and params[:stock_hold][:sell_quantity].to_s !=""
      params[:stock_hold][:profit_loss_mny]=(params[:stock_hold][:sell_quantity].to_i * params[:stock_hold][:sell_rate_mny].to_i - params[:stock_hold][:sell_quantity].to_i * params[:stock_hold][:buy_rate_mny].to_i - params[:stock_hold][:expenses_mny].to_i)
    else
      #譲渡でないため、譲渡損益クリア
      params[:stock_hold][:profit_loss_mny]=nil
    end

    @stock_hold = StockHold.new(stock_hold_params)
    @stock_hold.user_id =current_user.id

    #国内株式 かつ 譲渡銘柄の場合、譲渡時の銘柄名を取得し登録
    if @stock_hold.stock_type == Settings.stock_type.jpn_stock && !@stock_hold.sell_date.nil?
      rec =StockInfo.find_by(stock_code: @stock_hold.stock_code)
      if !rec.nil?
        @stock_hold.stock_name=rec.stock_name
      end
    end

    #登録
    respond_to do |format|
      if @stock_hold.save
        format.html { redirect_to @stock_hold, notice: '銘柄情報を登録しました。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @p_list = params[:p_list].to_s

    if @p_list == Settings.stock_holds_mode.profitloss_cancel
      #譲渡取消
      respond_to do |format|
        if @stock_hold.update_attributes(:sell_date => nil, :sell_rate_mny => nil,:sell_quantity => nil,:expenses_mny => nil,:profit_loss_mny => nil)
          format.html { redirect_to @stock_hold , notice: '譲渡取消を行い、保有銘柄にしました。' }
        else
          format.html { render :edit }
        end
      end
    else
      StockHold.transaction do
        #編集
        if params[:stock_hold][:sell_rate_mny].to_s!="" && params[:stock_hold][:sell_quantity].to_s!="" && params[:stock_hold][:sell_date].to_s!=""
          #譲渡損益を算出し設定
          params[:stock_hold][:profit_loss_mny]=(params[:stock_hold][:sell_quantity].to_i * params[:stock_hold][:sell_rate_mny].to_i - params[:stock_hold][:sell_quantity].to_i * params[:stock_hold][:buy_rate_mny].to_i - params[:stock_hold][:expenses_mny].to_i)

          #国内株式 かつ 譲渡銘柄の場合、譲渡時の銘柄名を取得し登録
          if params[:stock_hold][:stock_type] == Settings.stock_type.jpn_stock && !params[:stock_hold][:sell_date].nil?
            rec =StockInfo.find_by(stock_code: params[:stock_hold][:stock_code])
            if !rec.nil?
              params[:stock_hold][:stock_name]=rec.stock_name
            end
          end

          #譲渡株数が取得株数より小さい場合（一部譲渡）、保有、譲渡とレコードを分けて登録する。
          if params[:stock_hold][:sell_quantity].to_i < params[:stock_hold][:buy_quantity].to_i
            #残株の保有レコードを新規作成
            @stock_hold2 = StockHold.new(stock_hold_params)
            @stock_hold2.user_id=current_user.id
            @stock_hold2.bank_id = @stock_hold.bank_id
            #国内株式の場合、保有の銘柄名はブランクで登録
            if params[:stock_hold][:stock_type] == Settings.stock_type.jpn_stock
              @stock_hold2.stock_name=nil
            end
            @stock_hold2.buy_quantity = params[:stock_hold][:buy_quantity].to_i - params[:stock_hold][:sell_quantity].to_i
            @stock_hold2.sell_date = nil
            @stock_hold2.sell_rate_mny = nil
            @stock_hold2.sell_quantity = nil
            @stock_hold2.expenses_mny = nil
            @stock_hold2.profit_loss_mny = nil
            #現レコードの取得株数から譲渡株数を差し引く
            params[:stock_hold][:buy_quantity] = params[:stock_hold][:sell_quantity]
            #一部譲渡の場合は、チェック対象外
            #@stock_hold2.skip_buy_limit_over=true
          end
        else
          #保有銘柄の編集
          params[:stock_hold][:profit_loss_mny]=nil
        end

        respond_to do |format|
          #編集データ登録
          if @stock_hold.update(stock_hold_params)
            if !@stock_hold2.nil?
              #残株の保有レコード登録
              if @stock_hold2.save
                #残株の保有レコードを登録結果に表示するため、flashにデータ格納
                flash[:stock_hold2]=@stock_hold2
                format.html { redirect_to @stock_hold , notice: '銘柄情報を更新しました。' }
              # else
              #   begin
              #     #一部譲渡で取得単価を大きくした際に、NISA年度の枠を超えた場合、エラーとなるためrollbackする
              #     raise ActiveRecord::Rollback
              #   rescue => e
              #     p e.message
              #   end
              #   format.html { render :edit }
              end
            else
              format.html { redirect_to @stock_hold , notice: '銘柄情報を更新しました。' }
            end
          else
            format.html { render :edit }
          end
        end
      end
    end
  end

  def destroy
    #削除後のURL編集
    if (request.referrer.to_s.include?(stock_holds_path+"/list"))
      #保有銘柄リストに遷移
      redirect_url=request.referrer.to_s
    else
      if !@stock_hold.sell_quantity.nil?
        #譲渡の場合、譲渡銘柄リストに遷移
        redirect_url=stock_holds_path+"/list/profitloss_year"
      else
        #譲渡でない場合、保有銘柄リストに遷移
        redirect_url=stock_holds_path+"/list/year"
      end
    end

    #削除
    @stock_hold.destroy
    respond_to do |format|
      format.html { redirect_to redirect_url, notice: '対象銘柄を削除しました。' }
    end
  end

  private
    def set_stock_hold
      @stock_hold = StockHold.joins("INNER JOIN banks ON stock_holds.bank_id = banks.id and stock_holds.user_id = banks.user_id").where("stock_holds.user_id = ?",current_user.id )
                                   .select("banks.year as bank_year,banks.name as bank_name,banks.opt as bank_opt,stock_holds.*").find_by_id(params[:id])

      #不正URLアクセス時は、強制的に保有銘柄一覧に遷移
      return redirect_to "/stock_holds/list/" + Settings.stock_holds_list.year if @stock_hold.nil?

      #国内株式の場合、銘柄名取得
      if @stock_hold.stock_type == Settings.stock_type.jpn_stock
        rec = StockInfo.find_by(stock_code: @stock_hold.stock_code)
        if !rec.nil?
          @stock_hold.stock_name=rec.stock_name
        end
      end

      #口座名を表示用に取得
      @bank_opt_name=SystemCode.where("opt='006' and system_codes.key =?",@stock_hold.bank_opt).records[0].name

      #NISA口座の有効期限切れの有無取得
      @bank_expire_flg = Bank.where("id =?",@stock_hold.bank_id).records[0].expire_flg
    end

    # 登録、更新パラメーターの許可制限を設定
    def stock_hold_params
      params.require(:stock_hold).permit(:bank_id , :stock_code,:stock_type,:stock_name, :buy_date,
                                         :buy_rate_mny, :buy_quantity, :sell_date, :sell_rate_mny, :sell_quantity, :expenses_mny, :profit_loss_mny)
    end

    #ページタイトル設定
    def set_stock_hold_name(p)
      case p.to_s
        when Settings.stock_holds_list.assets then
          return Settings.stock_holds_list_name.assets
        when Settings.stock_holds_list.year then
          return Settings.stock_holds_list_name.year
        when Settings.stock_holds_list.stock then
          return Settings.stock_holds_list_name.stock
        when Settings.stock_holds_list.bank then
          return Settings.stock_holds_list_name.bank
        when Settings.stock_holds_list.profit_current then
          return Settings.stock_holds_list_name.profit_current
        when Settings.stock_holds_list.loss_current then
          return Settings.stock_holds_list_name.loss_current
        when Settings.stock_holds_list.profit_loss_year then
          return Settings.stock_holds_list_name.profit_loss_year
        when Settings.stock_holds_list.profit_loss_stock then
          return Settings.stock_holds_list_name.profit_loss_stock
        when Settings.stock_holds_list.profit_loss_bank then
          return Settings.stock_holds_list_name.profit_loss_bank
        when Settings.stock_holds_list.profit_loss_profit then
          return Settings.stock_holds_list_name.profit_loss_profit
        when Settings.stock_holds_list.profit_loss_loss then
          return Settings.stock_holds_list_name.profit_loss_loss
        when Settings.stock_holds_list.monitor then
          return Settings.stock_holds_list_name.monitor
        else
          return ""
      end
    end
end
