#お知らせ
class MessagesController < ApplicationController
  include CommonModule
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :sign_in_required

  def index
    #既読かつ削除は表示対象から除外
    @messages = Message.joins("LEFT JOIN message_reads on messages.id=message_reads.message_id").where("messages.user_id=? or messages.user_id is null",current_user.id.to_s)
                    .select("messages.*,message_reads.read_flg,message_reads.delete_flg")
                    .order("messages.created_at desc")
                    .where.not(id: MessageRead.where("message_reads.user_id=? and delete_flg=?",current_user.id,true).select("message_id"))

    #ページング
    @messages = @messages.page(params[:page]).per(5)
  end

  def show
    #お知らせを既読に設定
    #お知らせのメールアドレス指定がある場合 と メールアドレス指定がない場合 の２種類のメッセージを取得
    if MessageRead.find_by(user_id: current_user.id, message_id: @message.id).nil?
      message_read = MessageRead.new
      message_read.message_id = @message.id
      message_read.user_id =current_user.id
      message_read.read_flg = true
      message_read.delete_flg = false
      if message_read.save
        flash.now[:notice] = "お知らせを既読にしました。"
      else
        flash.now[:notice] = "お知らせの既読に失敗しました。インターネット接続またはWebサービスが一時的に問題が出ています。"
      end
    end
  end

  def new
    if check_role(current_user)
      @message = Message.new
    end
  end

  def edit
    check_role(current_user)
  end

  def create
    if check_role(current_user)
      @message = Message.new(message_params)
      @message.user_id =current_user.id
      respond_to do |format|
        if @message.save
          format.html { redirect_to @message, notice: 'お知らせを登録しました。' }
        else
          format.html { render :new }
        end
      end
    end
  end

  def update
    if check_role(current_user)
      respond_to do |format|
        if @message.update(message_params)
          format.html { redirect_to @message, notice: 'お知らせを更新しました。' }
        else
          format.html { render :edit }
        end
      end
    end
  end

  def destroy
    message_read = MessageRead.find_by(user_id: current_user.id, message_id: @message.id)
    if !message_read.nil?
      message_read.delete_flg = true
      if message_read.save
        redirect_to messages_url, notice: '対象のお知らせを削除しました。'
      else
        redirect_to messages_url, notice: '対象のお知らせの削除に失敗しました。インターネット接続またはWebサービスが一時的に問題が出ています。'
      end
    end
  end

  private
    def set_message
      @message = Message.where("user_id = "  +current_user.id.to_s + " or user_id is null or user_id =''").find_by_id(params[:id])
    end

    def message_params
      params.require(:message).permit(:user_id, :send_date, :subject, :body)
    end
end
