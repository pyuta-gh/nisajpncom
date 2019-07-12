class CreateStockInfoChangeMails < ActiveRecord::Migration[5.0]
  def change
    create_table :stock_info_change_mails do |t|
      t.string :user_id
      t.string :stock_code
      t.string :stock_name
      t.integer :end_rate_mny
      t.string :change_type
      t.string :stock_message
      t.date :target_date

      t.timestamps
    end
  end
end
