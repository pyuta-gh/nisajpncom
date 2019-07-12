class AddKeyToSystemCodes < ActiveRecord::Migration[5.0]
  def change
    add_column :system_codes, :key, :string
  end
end
