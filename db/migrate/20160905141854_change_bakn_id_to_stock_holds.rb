class ChangeBaknIdToStockHolds < ActiveRecord::Migration[5.0]
  def change
    change_column(:stock_holds, :bank_id, :string, :limit => 50)
    rename_column :stock_holds, :bank_id, :bank_name
  end
end
