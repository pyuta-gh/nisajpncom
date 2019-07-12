class ChangeIntgerUserIdOfStockMonitors < ActiveRecord::Migration[5.0]
  def change
    change_column(:stock_monitors, :user_id, :integer)
  end
end
