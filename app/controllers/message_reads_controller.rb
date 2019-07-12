#お知らせ既読管理
class MessageReadsController < ApplicationController
  include CommonModule
  before_action :set_message_read, only: [:show, :edit, :update, :destroy]
  before_action :sign_in_required

  def index
    if check_role(current_user)
      @message_reads = MessageRead.where("user_id = '"  +current_user.id.to_s + "'")
                           .order("id")
      #ページング
      @message_reads = @message_reads.page(params[:page]).per(5)
    end
  end

  def show
    check_role(current_user)
  end

  def new
    if check_role(current_user)
      @message_read = MessageRead.new
    end
  end

  def edit
    check_role(current_user)
  end

  def create
    if check_role(current_user)
      @message_read = MessageRead.new(message_read_params)
      @message_read.user_id =current_user.id
      respond_to do |format|
        if @message_read.save
          format.html { redirect_to @message_read, notice: 'お知らせの既読、削除情報を登録しました。' }
        else
          format.html { render :new }
        end
      end
    end
  end

  def update
    if check_role(current_user)
      respond_to do |format|
        if @message_read.update(message_read_params)
          format.html { redirect_to @message_read, notice: 'お知らせの既読、削除情報を登録しました。' }
        else
          format.html { render :edit }
        end
      end
    end
  end

  def destroy
    if check_role(current_user)
      @message_read.destroy
      respond_to do |format|
        format.html { redirect_to message_reads_url, notice: '対象のお知らせの既読、削除情報を削除しました。' }
      end
    end
  end

  private
    def set_message_read
      @message_read = MessageRead.where("user_id = "  +current_user.id.to_s ).find_by_id(params[:id])
    end

    def message_read_params
      params.require(:message_read).permit(:message_id, :user_id, :read_flg, :delete_flg)
    end
end
