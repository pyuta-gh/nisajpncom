class ChangeDecimal2PayRateMnyToDividends < ActiveRecord::Migration[5.0]
  def change
    change_column(:dividends, :pay_rate_mny,:decimal, :precision => 9, :scale => 2)
  end
end
