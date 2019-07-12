class ChangeTextBodyOfSystemInfos < ActiveRecord::Migration[5.0]
  def change
    change_column(:system_infos, :body, :text)
  end
end
