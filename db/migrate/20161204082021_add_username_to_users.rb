class AddUsernameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :username, :string
    add_column :users, :birth, :date
    add_column :users, :mail_enabled, :boolean
  end
end
