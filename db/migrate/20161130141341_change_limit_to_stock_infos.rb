class ChangeLimitToStockInfos < ActiveRecord::Migration[5.0]
  def change
    change_column(:stock_infos, :buy_sell_quantity, :integer, :limit => 8)
    change_column(:stock_infos, :trading_sum_mny, :integer, :limit => 8)
  end
end
