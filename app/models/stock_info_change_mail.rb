#銘柄異動情報メール
class StockInfoChangeMail < ApplicationRecord
  #必須チェック
  validates :change_type, presence: true
  validates :stock_code, presence: true
  validates :stock_message, presence: true
  validates :target_date, presence: true

  #日付チェック
  validates_datetime :target_date

  #範囲チェック
  validates :change_type, :inclusion => ['1', '2', '3', '4', '5']

  #半角数字チェック
  validates :stock_code, numericality: {
                           only_integer: true, greater_than_or_equal_to: 1000,less_than_or_equal_to:9999
                       }
end

