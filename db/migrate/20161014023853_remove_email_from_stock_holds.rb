class RemoveEmailFromStockHolds < ActiveRecord::Migration[5.0]
  def change
    remove_column :stock_holds, :email, :string
  end
end
