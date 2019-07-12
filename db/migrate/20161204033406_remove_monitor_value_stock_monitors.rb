class RemoveMonitorValueStockMonitors < ActiveRecord::Migration[5.0]
  def change
    remove_column :stock_monitor_mails, :monitor_value, :integer
  end
end
