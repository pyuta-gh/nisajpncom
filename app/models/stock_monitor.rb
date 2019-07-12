#銘柄ウオッチ
class StockMonitor < ApplicationRecord
  #結合
  belongs_to :user

  #必須チェック
  validates :stock_code, presence: true
  validates :monitor_type, presence: true
  validates :value, presence: true

  #半角数字チェック
  validates :value, numericality: {only_integer: true, greater_than: 0,less_than_or_equal_to:9999999}

  #銘柄コードチェック
  validates :stock_code, numericality: {
                           only_integer: true, greater_than_or_equal_to: 1000,less_than_or_equal_to:9999,allow_blank: false
                       }

  #範囲チェック
  validates :monitor_type, :inclusion => ['1', '2']

  #銘柄コードの存在チェック
  validate :stock_name_chk
  def stock_name_chk
    if !StockInfo.exists?(stock_code: stock_code)
      errors.add(:stock_code, "は存在する値を入力してください")
    end
  end
end
