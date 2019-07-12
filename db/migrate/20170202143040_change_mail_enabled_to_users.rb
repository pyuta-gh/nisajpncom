class ChangeMailEnabledToUsers < ActiveRecord::Migration[5.0]
  def change
    change_column(:users, :mail_enabled,:boolean, null: false, default: true)
  end
end
