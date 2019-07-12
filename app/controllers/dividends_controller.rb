#配当金情報
class DividendsController < ApplicationController
  before_action :set_dividend, only: [:show, :edit, :update, :destroy]
  before_action :sign_in_required
  def index
    #Ransack検索キー
    @q = Dividend.ransack(params[:q])
    @dividends=@q.result.joins("INNER JOIN system_codes as stock_type_code ON dividends.stock_type = stock_type_code.key and stock_type_code.opt = '003'")
                   .joins("INNER JOIN banks on banks.id = dividends.bank_id  and dividends.user_id = banks.user_id")
                   .joins("INNER JOIN system_codes as bank_type_code ON banks.opt = bank_type_code.key and bank_type_code.opt = '006'")
                   .where("dividends.user_id = '"  +current_user.id.to_s + "'").order("pay_date asc")
                   .select("dividends.*,stock_type_code.name as stock_type_name,bank_type_code.name as bank_type_name,banks.name as bank_name,banks.year as bank_year")

    #ページング
    @dividends = @dividends.page(params[:page]).per(5)
  end

  def show
  end

  def new
    @dividend = Dividend.new
    if !params[:p_bank_id].nil?
      @dividend.bank_id = params[:p_bank_id]
    end
    if !params[:p_stock_type].nil?
      @dividend.stock_type = params[:p_stock_type]
    end
    if !params[:p_stock_code].nil?
      @dividend.stock_code = params[:p_stock_code]
    end
    if !params[:p_stock_name].nil?
      @dividend.stock_name = params[:p_stock_name]
    end
  end

  def edit
  end

  def create
    @dividend = Dividend.new(dividend_params)
    @dividend.user_id =current_user.id

    #日本株式の場合、銘柄名を取得し、保存
    if Settings.stock_type.jpn_stock == @dividend.stock_type
      rec= StockInfo.where("stock_code =?",@dividend.stock_code).first
      if !rec.nil?
        @dividend.stock_name = rec.stock_name
      end
    end

    respond_to do |format|
      if @dividend.save
        format.html { redirect_to @dividend, notice: '配当金・分配金を登録しました。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    #日本株式の場合、銘柄名を取得し、保存
    if Settings.stock_type.jpn_stock == params[:dividend][:stock_type]
      rec= StockInfo.where("stock_code =?",params[:dividend][:stock_code]).first
      if !rec.nil?
        params[:dividend][:stock_name]=rec.stock_name
      end
    end

    respond_to do |format|

      if @dividend.update(dividend_params)
        format.html { redirect_to @dividend, notice: '配当金・分配金を更新しました。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @dividend.destroy
    respond_to do |format|
      format.html { redirect_to dividends_url, notice: '対象の配当金・分配金を削除しました。' }
    end
  end

  private
    def set_dividend
      @dividend = Dividend.where("user_id = "  +current_user.id.to_s).find_by_id(params[:id])
      @dividend_2=Dividend.joins("INNER JOIN system_codes as stock_type_code ON dividends.stock_type = stock_type_code.key and stock_type_code.opt = '003'")
                     .joins("INNER JOIN banks on banks.id = dividends.bank_id  and dividends.user_id = banks.user_id")
                     .joins("INNER JOIN system_codes as bank_type_code ON banks.opt = bank_type_code.key and bank_type_code.opt = '006'")
                     .where("dividends.user_id = '"  +current_user.id.to_s + "' and dividends.id=? ",params[:id])
                     .select("dividends.stock_type as stock_type,stock_type_code.name as stock_type_name,bank_type_code.name as bank_type_name,banks.opt as bank_opt,banks.year as bank_year,banks.name as bank_name")
                      .first
    end

    def dividend_params
      params.require(:dividend).permit(:pay_date, :stock_code, :stock_name, :pay_rate_mny, :pay_quantity, :pay_profit_mny,:user_id,:bank_id,:stock_type)
    end
end
