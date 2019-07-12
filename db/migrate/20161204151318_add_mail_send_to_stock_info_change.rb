class AddMailSendToStockInfoChange < ActiveRecord::Migration[5.0]
  def change
    add_column :stock_info_changes, :mail_send, :boolean
  end
end
