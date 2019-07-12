class AddExpireFlgToBank < ActiveRecord::Migration[5.0]
  def change
    add_column :banks, :expire_flg, :boolean
  end
end
