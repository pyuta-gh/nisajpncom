class ChangeDatatypePubdateOfTopics < ActiveRecord::Migration[5.0]
  def change
    change_column(:topics, :pubDate, :date)
    change_column(:system_infos, :send_date, :date)
  end
end
