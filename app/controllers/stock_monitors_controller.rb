class StockMonitorsController < ApplicationController
  before_action :set_stock_monitor, only: [:show, :edit, :update, :destroy]
  before_action :sign_in_required
  include ApplicationHelper

  def index
    @stock_monitors = User.joins(:stock_monitors)
                          .joins("LEFT JOIN stock_infos ON stock_infos.stock_code = stock_monitors.stock_code")
                          .joins("INNER JOIN system_codes ON stock_monitors.monitor_type = system_codes.key and opt = '004'")
                          .where("users.id = ?" ,current_user.id )
                          .select("stock_monitors.*,stock_infos.stock_name stock_code_name,system_codes.name as monitor_name")
    #ページング
    @stock_monitors = @stock_monitors.page(params[:page]).per(5)
  end

  def show
    @monitor_type_name = SystemCode.where("opt = ? and system_codes.key = ?",'004',@stock_monitor.monitor_type).records[0].name
  end

  def new
    p_list = params[:p_list]

    @stock_monitor = StockMonitor.new

    if !p_list.nil?
      if (is_numeric?(p_list))
        @stock_monitor.stock_code= p_list
      end
    end
  end

  def edit
  end

  def create
    @stock_monitor = StockMonitor.new(stock_monitor_params)
    @stock_monitor.user_id =current_user.id
    respond_to do |format|
      if @stock_monitor.save
        format.html { redirect_to @stock_monitor, notice: 'ウォッチリストを登録しました。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @stock_monitor.update(stock_monitor_params)
        format.html { redirect_to @stock_monitor, notice: 'ウォッチリストを更新しました。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @stock_monitor.destroy
    respond_to do |format|
      format.html { redirect_to stock_monitors_url, notice: '対象のウォッチリストを削除しました。' }
    end
  end

  private
    def set_stock_monitor
      @stock_monitor = StockMonitor.where("user_id = ?",current_user.id ).find_by_id(params[:id])

      #不正URLアクセス時は、強制的にウオッチリストに遷移
      return redirect_to "/stock_monitors" if @stock_monitor.nil?
    end

    def stock_monitor_params
      params.require(:stock_monitor).permit(:stock_code, :monitor_type, :value)
    end
end
