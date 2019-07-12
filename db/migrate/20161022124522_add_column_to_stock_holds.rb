class AddColumnToStockHolds < ActiveRecord::Migration[5.0]
  def change
    add_column :stock_holds, :stock_type, :string
    add_column :stock_holds, :stock_name, :string
  end
end
