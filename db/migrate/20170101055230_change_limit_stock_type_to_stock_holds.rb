class ChangeLimitStockTypeToStockHolds < ActiveRecord::Migration[5.0]
  def change
    change_column(:stock_holds, :stock_type, :string)
  end
end
