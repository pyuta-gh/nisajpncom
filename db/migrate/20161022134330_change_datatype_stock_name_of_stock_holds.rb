class ChangeDatatypeStockNameOfStockHolds < ActiveRecord::Migration[5.0]
  def change
    change_column(:stock_holds, :stock_name, :string, :limit => 50)
  end
end
