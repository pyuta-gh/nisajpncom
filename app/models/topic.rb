class Topic < ApplicationRecord
  #共通 正規表現
  include RegexValidators

  #必須
  validates :category, presence: true
  validates :title, presence: true
  validates :link, presence: true
  validates :pubDate, presence: true

  #日付チェック
  validates_datetime :pubDate

end
