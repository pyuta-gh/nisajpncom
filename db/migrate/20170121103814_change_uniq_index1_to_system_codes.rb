class ChangeUniqIndex1ToSystemCodes < ActiveRecord::Migration[5.0]
  def change
    add_index :system_codes, [:opt, :key], :unique => true, :name => 'system_code_uniq_index'
  end
end
