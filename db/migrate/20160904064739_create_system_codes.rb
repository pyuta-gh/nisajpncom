class CreateSystemCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :system_codes do |t|
      t.string :opt
      t.string :name

      t.timestamps
    end
  end
end
