class RenameJuniorColumnToBanks < ActiveRecord::Migration[5.0]
  def change
    rename_column :banks, :junior, :opt
  end
end
