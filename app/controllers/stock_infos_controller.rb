class StockInfosController < ApplicationController
  include CommonModule
  before_action :set_stock_info, only: [:show, :edit, :update, :destroy]

  #ActionController::InvalidAuthenticityTokenエラー回避
  #TODO 何故か、search2以外も全て回避となるため、見直し
  protect_from_forgery except: :search2

  include ApplicationHelper
  
  def index
    #メニューからの初期表示のフラグを設定（検索ボタンによる表示でないフラグ設定）
    if params[:commit].nil? and params[:q].nil?
      @btn_search=false
    else
      @btn_search=true
    end
    @q = StockInfo.joins("INNER JOIN system_codes ON stock_infos.market_code = system_codes.key and opt = '002'")
             .select("stock_infos.*,system_codes.name as market_name").ransack(params[:q])
    @stock_infos = @q.result

    #ページング
    @stock_infos = @stock_infos.page(params[:page]).per(5)
   end

  def show
    #株式分類コードに無理やり名称を入れているため、よくないかも。
    @market_name = SystemCode.find_by(opt: '002', key: @stock_info.market_code).name
  end

  def new
    if check_role(current_user)
      @stock_info = StockInfo.new
    end
  end

  def edit
    check_role(current_user)
  end

  def create
    if check_role(current_user)
      @stock_info = StockInfo.new(stock_info_params)

      respond_to do |format|
        if @stock_info.save
          format.html { redirect_to @stock_info, notice: '銘柄情報を登録しました。' }
        else
          format.html { render :new }
        end
      end
    end
  end

  def update
    if check_role(current_user)
      respond_to do |format|
        if @stock_info.update(stock_info_params)
          format.html { redirect_to @stock_info, notice: '銘柄情報を更新しました。' }
        else
          format.html { render :edit }
        end
      end
    end
  end

  def destroy
    if check_role(current_user)
      @stock_info.destroy
      respond_to do |format|
        format.html { redirect_to stock_infos_url, notice: '対象の銘柄情報を削除しました。' }
      end
    end
  end

  #保有銘柄登録、ウオッチリスト、配当情報の銘柄コードのチェンジイベント時の銘柄名の取得用
  def search
    p_list = params[:p_list]
    if p_list != "undefined"
      if !p_list.nil?
        if (is_numeric?(p_list))
          @stock_infos = StockInfo.find_by(stock_code: p_list)
        end
        render :json =>@stock_infos
      end
    end
  end

  #メニューの銘柄入力による検索
  def search2
    p_list = params[:p_list]

    if p_list.to_s!=""
      @btn_search = true
      #銘柄コード検索
      if (is_numeric?(p_list))
        @q = StockInfo.joins("INNER JOIN system_codes ON stock_infos.market_code = system_codes.key and opt = '002'")
                 .where("stock_code = '" + p_list + "'")
                 .select("stock_infos.*,system_codes.name as market_name")
                 .ransack(params[:q])
      else
        #銘柄名検索
        @q = StockInfo.joins("INNER JOIN system_codes ON stock_infos.market_code = system_codes.key and opt = '002'")
                 .where("stock_name like '%" + p_list + "%'")
                 .select("stock_infos.*,system_codes.name as market_name")
                 .ransack(params[:q])
      end
      @stock_infos = @q.result

      #ページング
      @stock_infos = @stock_infos.page(params[:page]).per(5)

      render :template => 'stock_infos/index'
    end
  end

  #銘柄検索の一覧の保有銘柄登録ボタンから対象銘柄の保有登録
  def hold
    p_list = params[:p_list]

    if !p_list.nil?
      if (is_numeric?(p_list))
        #銘柄コードをflushに退避
        flash[:stock_code] = p_list
        #保有銘柄の新規登録に遷移
        redirect_to "/stock_holds/new/"  + Settings.stock_holds_mode.hold_new
      end
    end
  end

  private
    def set_stock_info
      @stock_info = StockInfo.find(params[:id])
    end

    def stock_info_params
      params.require(:stock_info).permit(:market_code, :stock_code, :stock_name, :end_rate_mny, :start_rate_mny,:max_rate_mny,:min_rate_mny,:buy_sell_quantity,:trading_sum_mny)
    end
end
