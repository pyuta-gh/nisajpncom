class ChangeStockInfos < ActiveRecord::Migration[5.0]
  def change
    add_column :stock_infos, :start_rate_mny, :integer
    add_column :stock_infos, :max_rate_mny, :integer
    add_column :stock_infos, :min_rate_mny, :integer
    add_column :stock_infos, :end_rate_mny, :integer
    add_column :stock_infos, :buy_sell_quantity, :integer
    add_column :stock_infos, :trading_sum_mny, :integer
  end
end
