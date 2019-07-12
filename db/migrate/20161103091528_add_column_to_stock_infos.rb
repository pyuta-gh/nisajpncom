class AddColumnToStockInfos < ActiveRecord::Migration[5.0]
  def change
    add_column :stock_infos, :buy_lowest_mny, :integer
  end
end
