class ChangeStockMonitorMail < ActiveRecord::Migration[5.0]
  def change
    rename_column :stock_monitor_mails, :rate_mny, :monitor_mny
    add_column :stock_monitor_mails, :end_rate_mny, :integer
    add_column :stock_monitor_mails, :min_rate_mny, :integer
    add_column :stock_monitor_mails, :max_rate_mny, :integer
  end
end
