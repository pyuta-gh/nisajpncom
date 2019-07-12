class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #   and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:confirmable, :lockable,:timeoutable

  #usernameを必須
  validates :username, presence: true

  #文字数
  validates :username,length: { minimum: 4, maximum: 20 }

  #６文字以上の英数混在で入力
  validate :password_check
  def password_check
    if errors.count==0 && !password.nil?
      validates_format_of :password, :with => /([0-9].*[a-zA-Z]|[a-zA-Z].*[0-9])/, :message => "は６文字以上の英数字混在で入力してください。"
    end
    if errors.count==0 && !current_password.nil?
      validates_format_of :current_password, :with => /([0-9].*[a-zA-Z]|[a-zA-Z].*[0-9])/, :message => "は６文字以上の英数字混在で入力してください。"
    end
  end

  #削除(destroy)はstock_holds、dividends、banksの順番でないとモデルの存在エラーで削除できなくなる
  has_many :stock_holds, :dependent => :destroy
  has_many :dividends, :dependent => :destroy
  has_many :banks, :dependent => :destroy
  has_many :message_reads, :dependent => :destroy
  has_many :messages, :dependent => :destroy
  has_many :stock_monitors, :dependent => :destroy

end
