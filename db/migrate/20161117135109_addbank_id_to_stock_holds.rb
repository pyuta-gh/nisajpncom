class AddbankIdToStockHolds < ActiveRecord::Migration[5.0]
  def change
    add_column :stock_holds, :bank_id, :integer
  end
end
