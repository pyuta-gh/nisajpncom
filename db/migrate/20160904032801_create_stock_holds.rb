class CreateStockHolds < ActiveRecord::Migration[5.0]
  def change
    create_table :stock_holds do |t|
      t.string :user_id
      t.string :bank_id
      t.string :nisa_year
      t.string :market_code
      t.string :stock_code
      t.string :trade_type
      t.date :buy_date
      t.integer :buy_rate_mny
      t.integer :buy_quantity
      t.date :sell_date
      t.integer :sell_rate_mny
      t.integer :sell_quantity
      t.integer :expenses_mny
      t.integer :profit_loss_mny

      t.timestamps
    end
  end
end
