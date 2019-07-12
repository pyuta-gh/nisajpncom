class CreateMessageReads < ActiveRecord::Migration[5.0]
  def change
    create_table :message_reads do |t|
      t.integer :message_id
      t.string :user_id
      t.boolean :read_flg
      t.boolean :delete_flg

      t.timestamps
    end
  end
end
