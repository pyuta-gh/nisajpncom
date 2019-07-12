class AddSortToSystemCodes < ActiveRecord::Migration[5.0]
  def change
    add_column :system_codes, :sort, :string
  end
end
