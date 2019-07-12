class AddemoveBirthFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :birth, :date
  end
end
