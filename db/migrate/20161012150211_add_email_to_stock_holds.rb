class AddEmailToStockHolds < ActiveRecord::Migration[5.0]
  def change
    add_column :stock_holds, :email, :string
  end
end
