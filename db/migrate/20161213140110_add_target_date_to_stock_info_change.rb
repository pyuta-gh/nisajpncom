class AddTargetDateToStockInfoChange < ActiveRecord::Migration[5.0]
  def change
    add_column :stock_info_changes, :target_date, :date
  end
end
