class ChangeStockCodeToStockHolds < ActiveRecord::Migration[5.0]
  def change
    change_column(:stock_holds, :stock_code, :string, :limit => 15)
  end
end
