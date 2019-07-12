class CreateSystemInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :system_infos do |t|
      t.string :send_date
      t.string :subject
      t.string :body

      t.timestamps
    end
  end
end
