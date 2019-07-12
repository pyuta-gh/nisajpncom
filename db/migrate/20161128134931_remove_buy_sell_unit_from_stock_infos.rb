class RemoveBuySellUnitFromStockInfos < ActiveRecord::Migration[5.0]
  def change
    remove_column :stock_infos, :buy_sell_unit, :integer
    remove_column :stock_infos, :nisa_target_flg, :boolean
  end
end
