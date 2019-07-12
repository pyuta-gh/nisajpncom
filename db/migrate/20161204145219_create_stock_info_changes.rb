class CreateStockInfoChanges < ActiveRecord::Migration[5.0]
  def change
    create_table :stock_info_changes do |t|
      t.string :user_id
      t.string :change_type
      t.string :stock_code
      t.string :stock_message

      t.timestamps
    end
  end
end
