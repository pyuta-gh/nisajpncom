class ChangeDatatypeSendDateOfMessages < ActiveRecord::Migration[5.0]
  def change
    change_column(:messages, :send_date, :date)
  end
end
