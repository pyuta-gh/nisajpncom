#お問い合わせ
class InquiryController < ApplicationController
  #入力画面
  def index
    # 入力画面を表示
    @inquiry = Inquiry.new
    render :action => 'index'
  end

  #確認画面
  def confirm
    @inquiry = Inquiry.new(inquiry_params)
    # 入力値のチェック
    if @inquiry.valid?
      # OK。確認画面を表示
      render :action => 'confirm'
    else
      # NG。入力画面を再表示
      render :action => 'index'
    end
  end

  #メール送信、お問い合わせ完了画面
  def thanks
    # メール送信
    @inquiry = Inquiry.new(inquiry_params)
    InquiryMailer.received_email(@inquiry).deliver

    # 完了画面を表示
    render :action => 'thanks'
  end

  # 登録、更新パラメーターの許可制限を設定
  def inquiry_params
    params.require(:inquiry).permit(:name,:email,:message)
  end
end