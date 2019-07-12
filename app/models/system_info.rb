class SystemInfo < ApplicationRecord
  #必須
  validates :send_date, presence: true
  validates :subject, presence: true
  validates :body, presence: true

  #日付チェック
  validates_datetime :send_date

end
