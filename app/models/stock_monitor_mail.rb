#ウオッチリストメール
class StockMonitorMail < ApplicationRecord

  #必須チェック
  validates :stock_code, presence: true
  validates :monitor_type, presence: true
  validates :monitor_mny, presence: true
  validates :end_rate_mny, presence: true
  validates :max_rate_mny, presence: true
  validates :min_rate_mny, presence: true

  #半角数字チェック
  validates :monitor_mny, numericality: {only_integer: true, greater_than: 0,less_than_or_equal_to:9999999}
  validates :end_rate_mny, numericality: {
                             only_integer: true, greater_than_or_equal_to: 0
                         }
  validates :max_rate_mny, numericality: {
                             only_integer: true, greater_than_or_equal_to: 0
                         }
  validates :min_rate_mny, numericality: {
                             only_integer: true, greater_than_or_equal_to: 0
                         }

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
