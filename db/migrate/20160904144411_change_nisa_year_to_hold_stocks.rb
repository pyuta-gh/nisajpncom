class ChangeNisaYearToHoldStocks < ActiveRecord::Migration[5.0]
  def change
    change_column(:stock_holds, :nisa_year, :string, :limit => 4)
  end
end
