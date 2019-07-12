class RemoveUserIdFromStockInfoChanges < ActiveRecord::Migration[5.0]
  def change
    remove_column :stock_info_changes, :user_id, :string
  end
end
