class ChangeOptColumnToBanks < ActiveRecord::Migration[5.0]
  def change
    change_column(:banks, :opt, :string)
  end
end
