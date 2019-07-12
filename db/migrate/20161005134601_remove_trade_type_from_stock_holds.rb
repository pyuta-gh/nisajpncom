class RemoveTradeTypeFromStockHolds < ActiveRecord::Migration[5.0]
  def change
    remove_column :stock_holds, :trade_type, :string
  end
end
