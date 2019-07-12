class RemoveEndRateMnyFromStockInfos < ActiveRecord::Migration[5.0]
  def change
    remove_column :stock_infos, :end_rate_mny, :integer
  end
end
