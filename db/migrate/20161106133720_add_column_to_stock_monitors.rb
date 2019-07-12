class AddColumnToStockMonitors < ActiveRecord::Migration[5.0]
  def change
    add_column :stock_monitors, :user_id, :string
  end
end
