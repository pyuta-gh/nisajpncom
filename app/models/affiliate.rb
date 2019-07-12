class Affiliate < ApplicationRecord
  #必須チェック
  validates :company, presence: true
  validates :a_id, presence: true
  validates :a_tag, presence: true

  #文字数チェック
  validates :company,      length: { maximum: 20 }
  validates :a_id,      length: { maximum: 50 }
  validates :a_tag,      length: { maximum: 1000 }
end
