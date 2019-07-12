class AddStockNameStockMonitors < ActiveRecord::Migration[5.0]
  def change
    add_column :stock_monitor_mails, :stock_name, :string
  end
end
