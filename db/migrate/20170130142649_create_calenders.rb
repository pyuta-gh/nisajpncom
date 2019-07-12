class CreateCalenders < ActiveRecord::Migration[5.0]
  def change
    create_table :calenders do |t|
      t.string :opt
      t.date :holliday
      t.string :description

      t.timestamps
    end
  end
end
