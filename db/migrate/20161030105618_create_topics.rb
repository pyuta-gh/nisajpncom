class CreateTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :topics do |t|
      t.string :title
      t.string :link
      t.string :category
      t.string :pubDate

      t.timestamps
    end
  end
end
