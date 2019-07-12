#メール
class Inquiry
  include ActiveModel::Model
  attr_accessor :name, :email, :message
  #名前 50文字以内
  #メッセージ 1000文字

  #メールアドレスチェック
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,  format: { with: VALID_EMAIL_REGEX }

  #文字数チェック
  validates :name,      length: { maximum: 50 }
  validates :email,     length: { maximum: 50 }
  validates :message,   length: { maximum: 1000 }

  #必須入力チェック
  validate :error_must_input
  def error_must_input
    if name.blank?
      errors[:base] << "名前は必ず入力して下さい"
    end

    if email.blank?
      errors[:base] << "メールアドレスは必ず入力して下さい"
    end

    if message.blank?
      errors[:base] << "お問い合わせ内容は必ず入力して下さい"
    end
  end
end