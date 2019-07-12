class ChangeNameEmailOfStockMonitorMails < ActiveRecord::Migration[5.0]
  def change
    remove_column :stock_monitor_mails, :user_id, :string
    add_column :stock_monitor_mails, :email, :string
  end
end
