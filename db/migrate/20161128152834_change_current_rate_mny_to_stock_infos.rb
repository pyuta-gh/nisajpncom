class ChangeCurrentRateMnyToStockInfos < ActiveRecord::Migration[5.0]
  def change
    rename_column :stock_infos, :current_rate_mny, :end_rate_mny
  end
end
