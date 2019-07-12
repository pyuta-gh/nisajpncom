class RemovebankNameFromstockHolds < ActiveRecord::Migration[5.0]
  def change
    remove_column :stock_holds, :bank_name, :string
    remove_column :stock_holds, :nisa_year, :string
  end
end
