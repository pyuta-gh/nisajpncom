class AddCoulumnUserIdBankIdToDividends < ActiveRecord::Migration[5.0]
  def change
    add_column :dividends, :user_id, :integer
    add_column :dividends, :bank_id, :integer

  end
end
