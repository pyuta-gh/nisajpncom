class ChangeNameEmailOfStockInfoChangeMails < ActiveRecord::Migration[5.0]
  def change
    remove_column :stock_info_change_mails, :user_id, :string
    add_column :stock_info_change_mails, :email, :string
  end
end
