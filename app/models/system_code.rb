#メンテナンス情報
class SystemCode < ApplicationRecord
  #必須チェック
  validates :opt, presence: true
  validates :name, presence: true
  validates :key, presence: true

  #文字数チェック
  validates :opt, length: { is: 3 }
  validates :opt, numericality: {only_integer: true, greater_than: 0,less_than_or_equal_to:999}

  #ユニークチェック
  validates :opt, uniqueness: { scope: :key }
end
