class ChangeIntgerUserIdOfStockInfoChangeMails < ActiveRecord::Migration[5.0]
  def change
    change_column(:stock_holds, :user_id, :integer)
    change_column(:messages, :user_id, :integer)
    change_column(:message_reads, :user_id, :integer)
    change_column(:banks, :user_id, :integer)
  end
end
