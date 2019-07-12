class RemoveBuyLowestMnyFromStockInfos < ActiveRecord::Migration[5.0]
  def change
    remove_column :stock_infos, :buy_lowest_mny, :string
  end
end
