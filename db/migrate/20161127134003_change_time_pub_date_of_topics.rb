class ChangeTimePubDateOfTopics < ActiveRecord::Migration[5.0]
  def change
    change_column(:topics, :pubDate, :time)
  end
end
