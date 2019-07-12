class ChangeDecimalPayRateMnyToDividends < ActiveRecord::Migration[5.0]
  def change
    change_column(:dividends, :pay_rate_mny, :decimal)
  end
end
