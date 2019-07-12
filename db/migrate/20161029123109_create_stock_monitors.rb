class CreateStockMonitors < ActiveRecord::Migration[5.0]
  def change
    create_table :stock_monitors do |t|
      t.string :market_code
      t.string :stock_code
      t.string :monitor_type
      t.string :value

      t.timestamps
    end
  end
end
