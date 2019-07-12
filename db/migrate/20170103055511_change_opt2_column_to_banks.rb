class ChangeOpt2ColumnToBanks < ActiveRecord::Migration[5.0]
  def change
    change_column(:banks, :opt, :integer)
  end
end
