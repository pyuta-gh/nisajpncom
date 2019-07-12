class ChangeValueStockMonitors < ActiveRecord::Migration[5.0]
  def change
    change_column(:stock_monitors, :value, :integer)
  end
end
