class RemoveMarketCodeFromStockHolds < ActiveRecord::Migration[5.0]
  def change
    remove_column :stock_holds, :market_code, :string
  end
end
