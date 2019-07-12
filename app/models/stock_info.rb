#銘柄情報
class StockInfo < ApplicationRecord
  #共通 正規表現
  include RegexValidators

  #必須チェック
  validates :market_code, presence: true
  validates :stock_code, presence: true
  validates :stock_name, presence: true
  validates :end_rate_mny, presence: true
  validates :start_rate_mny, presence: true
  validates :max_rate_mny, presence: true
  validates :min_rate_mny, presence: true

  #半角数字チェック
  validates :stock_code, numericality: {
                           only_integer: true, greater_than_or_equal_to: 1000,less_than_or_equal_to:9999
                       }
  validates :end_rate_mny, numericality: {
                           only_integer: true, greater_than_or_equal_to: 0
                       }

  validates :start_rate_mny, numericality: {
                                 only_integer: true, greater_than_or_equal_to: 0
                             }
  validates :max_rate_mny, numericality: {
                                 only_integer: true, greater_than_or_equal_to: 0
                             }
  validates :min_rate_mny, numericality: {
                                 only_integer: true, greater_than_or_equal_to: 0
                             }
  validates :buy_sell_quantity, numericality: {
                                 only_integer: true, greater_than_or_equal_to: 0
                             }
  validates :trading_sum_mny, numericality: {
                                 only_integer: true, greater_than_or_equal_to: 0
                             }

  #同一市場で重複登録はエラー
  validate :unique_stock_code_chk, on: :create
  def unique_stock_code_chk
    if StockInfo.exists?(market_code: market_code,stock_code: stock_code)
      errors.add(:stock_code, "は、同一市場で既に登録されています")
    end
  end

end
