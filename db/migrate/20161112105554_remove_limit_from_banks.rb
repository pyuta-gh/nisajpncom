class RemoveLimitFromBanks < ActiveRecord::Migration[5.0]
  def change
    remove_column :banks, :limit, :integer
  end
end
