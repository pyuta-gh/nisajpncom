class SystemInfosController < ApplicationController
  include CommonModule
  before_action :set_system_info, only: [:show, :edit, :update, :destroy]
  before_action :sign_in_required

  def index
    @system_infos = SystemInfo.all
    #ページング
    @system_infos = @system_infos.page(params[:page]).per(5)
  end

  def show
  end

  def new
    if check_role(current_user)
      @system_info = SystemInfo.new
    end
  end

  def edit
    check_role(current_user)
  end

  def create
    if check_role(current_user)
      @system_info = SystemInfo.new(system_info_params)

      respond_to do |format|
        if @system_info.save
          format.html { redirect_to @system_info, notice: 'メンテナンス情報を登録しました。' }
        else
          format.html { render :new }
        end
      end
    end
  end

  def update
    if check_role(current_user)
      respond_to do |format|
        if @system_info.update(system_info_params)
          format.html { redirect_to @system_info, notice: 'メンテナンス情報を更新しました。' }
        else
          format.html { render :edit }
        end
      end
    end
  end

  def destroy
    if check_role(current_user)
      @system_info.destroy
      respond_to do |format|
        format.html { redirect_to system_infos_url, notice: '対象のメンテナンス情報を削除しました。' }
      end
    end
  end

  private
    def set_system_info
      @system_info = SystemInfo.find(params[:id])
    end

    def system_info_params
      params.require(:system_info).permit(:send_date, :subject, :body)
    end
end
