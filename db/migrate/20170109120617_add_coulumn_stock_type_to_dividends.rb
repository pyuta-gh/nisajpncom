class AddCoulumnStockTypeToDividends < ActiveRecord::Migration[5.0]
  def change
    add_column(:dividends, :stock_type, :string)
  end
end
