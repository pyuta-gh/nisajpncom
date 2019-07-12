#お知らせ一覧
class Message < ApplicationRecord
  #結合
  belongs_to :user

  #必須チェック
  validates :send_date, presence: true
  validates :subject, presence: true
  validates :body, presence: true

  #日付
  validates_datetime :send_date

end
