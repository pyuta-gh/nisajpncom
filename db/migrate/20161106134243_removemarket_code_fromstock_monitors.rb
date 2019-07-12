class RemovemarketCodeFromstockMonitors < ActiveRecord::Migration[5.0]
  def change
    remove_column :stock_monitors, :market_code, :string
  end
end
