class ChangeDatetimePubDateOfTopics < ActiveRecord::Migration[5.0]
  def change
    change_column(:topics, :pubDate, :datetime)
  end
end
