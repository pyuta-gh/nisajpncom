class CreateBanks < ActiveRecord::Migration[5.0]
  def change
    create_table :banks do |t|
      t.string :user_id
      t.integer :year
      t.string :name
      t.boolean :junior
      t.integer :limit

      t.timestamps
    end
  end
end
