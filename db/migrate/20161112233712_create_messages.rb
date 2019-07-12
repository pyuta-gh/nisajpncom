class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :user_id
      t.string :send_date
      t.string :subject
      t.string :body

      t.timestamps
    end
  end
end
