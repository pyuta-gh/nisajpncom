class ChangeDatatypeStockTypeOfStockHolds < ActiveRecord::Migration[5.0]
  def change
    change_column(:stock_holds, :stock_type, :string, :limit => 1)
  end
end
