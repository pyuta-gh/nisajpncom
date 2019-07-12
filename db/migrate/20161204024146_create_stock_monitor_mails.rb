class CreateStockMonitorMails < ActiveRecord::Migration[5.0]
  def change
    create_table :stock_monitor_mails do |t|
      t.string :user_id
      t.string :monitor_type
      t.string :stock_code
      t.integer :monitor_value
      t.integer :rate_mny

      t.timestamps
    end
  end
end
