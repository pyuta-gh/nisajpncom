class ChangeColumnToStockHolds < ActiveRecord::Migration[5.0]
  def change
    change_column(:stock_holds, :market_code, :string, :limit => 15)
    change_column(:stock_holds, :stock_code, :string, :limit => 15)
    change_column(:stock_holds, :trade_type, :string, :limit => 5)
    change_column(:stock_holds, :buy_rate_mny, :integer, :limit => 7)
    change_column(:stock_holds, :buy_quantity, :integer, :limit => 7)
    change_column(:stock_holds, :sell_rate_mny, :integer, :limit => 7)
    change_column(:stock_holds, :sell_quantity, :integer, :limit => 7)
    change_column(:stock_holds, :expenses_mny, :integer, :limit => 5)
    change_column(:stock_holds, :profit_loss_mny, :integer, :limit => 8)
    #change_column(:stock_holds, :profit_loss_mny, :integer, :limit => 9)

  end
end
