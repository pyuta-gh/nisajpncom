class CreateStockInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :stock_infos do |t|
      t.string :market_code
      t.string :stock_code
      t.string :stock_name
      t.integer :current_rate_mny
      t.integer :buy_sell_unit
      t.boolean :nisa_target_flg
      t.integer :buy_lowest_mny

      t.timestamps
    end
  end
end
