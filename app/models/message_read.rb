#お知らせ既読
class MessageRead < ApplicationRecord
  #結合
  belongs_to :user

  #必須チェック
  validates :message_id, presence: true

end
