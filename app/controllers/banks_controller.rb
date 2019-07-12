#口座管理
class BanksController < ApplicationController
  before_action :set_bank, only: [:show, :edit, :update, :destroy]
  before_action :sign_in_required
  include ApplicationHelper

  def index
    @banks = Bank.joins("LEFT JOIN (select bank_id,count(*) as bank_count from stock_holds where user_id ='" +current_user.id.to_s +  "' group by bank_id) as stock_holds ON stock_holds.bank_id = banks.id")
                 .joins("INNER JOIN system_codes as bank_opt on banks.opt = bank_opt.key and bank_opt.opt = '006'")
                 .where("user_id = '"  +current_user.id.to_s + "'")
                 .select("banks.*,stock_holds.bank_count,bank_opt.name as bank_opt_name")
                 .order("banks.opt,banks.year,banks.name,bank_opt.name")
    #ページング
    @banks = @banks.page(params[:page]).per(5)
  end

  def show
  end

  def new
    @bank = Bank.new
  end

  def edit
  end

  def create
    @bank = Bank.new(bank_params)
    @bank.user_id =current_user.id
    @bank.expire_flg =false
    respond_to do |format|
      if @bank.save
        format.html { redirect_to @bank, notice: 'NISA口座情報を登録しました。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @bank.update(bank_params)
        format.html { redirect_to @bank, notice: 'NISA口座情報を更新しました。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    if @result = @bank.destroy
      # 成功
      respond_to do |format|
        format.html { redirect_to banks_url, notice: '対象のNISA口座情報を削除しました。' }
      end
    else
      # 失敗
      respond_to do |format|
        format.html { redirect_to banks_url, notice: '削除対象のNISA口座には、保有・譲渡・配当のいずれかが登録されているため、削除できません。' }
      end
    end
  end

  #一覧から対象銘柄の保有登録
  def hold
    p_list = params[:p_list]

    if !p_list.nil?
      if (is_numeric?(p_list))
        #銘柄コードをflushに退避
        flash[:bank_id] = p_list
        #保有銘柄の新規登録に遷移
        redirect_to "/stock_holds/new/"  + Settings.stock_holds_mode.hold_new
      end
    end
  end

  private
    def set_bank
      @bank = Bank.where("user_id = "  +current_user.id.to_s).find_by_id(params[:id])
      if !@bank.nil?
        if StockHold.exists?(bank_id: params[:id])== true
          @stockHold_exist = true
        else
          @stockHold_exist = false
        end
        @bank_opt_name=SystemCode.where("opt='006' and system_codes.key =?",@bank.opt).records[0].name
      end
    end

    def bank_params
      params.require(:bank).permit(:user_id, :year, :name, :opt,:expire_flg)
    end
end
