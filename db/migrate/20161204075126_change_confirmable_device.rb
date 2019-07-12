class ChangeConfirmableDevice < ActiveRecord::Migration[5.0]
  def change
    #メール登録認証
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string
  end
end
