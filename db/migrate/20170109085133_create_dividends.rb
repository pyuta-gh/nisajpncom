class CreateDividends < ActiveRecord::Migration[5.0]
  def change
    create_table :dividends do |t|
      t.date :pay_date
      t.string :stock_code
      t.string :stock_name
      t.float :pay_rate_mny
      t.integer :pay_quantity
      t.integer :pay_profit_mny

      t.timestamps
    end
  end
end
