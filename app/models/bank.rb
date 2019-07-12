#口座
class Bank < ApplicationRecord
  #結合
  belongs_to :user
  has_many :stock_holds, :dependent => :restrict_with_error
  has_many :dividends, :dependent => :restrict_with_error

  #必須チェック
  validates :opt, presence: true
  validates :name, presence: true

  #文字数チェック
  validates :year,      length: { maximum: 4 }
  validates :name,      length: { maximum: 25 }

  #範囲チェック
  validates :opt, inclusion: {in: 1..4 }

  #口座種類別チェック
  validate :opt_chk
  def opt_chk
    if opt == 1 or opt ==2
      case year
        when 2014,2015
          if opt == 2
            errors.add(:opt, "は2016年より前は入力できません")
          end
      end
      if year.nil?
        errors.add(:year, "を入力してください")
      end
    else
      if !year.nil?
        errors.add(:year, "はNISA口座のみ入力できます")
      end
    end
  end

  #NISA年度口座種類名の編集
  def year_and_name
    case self.opt
      when 1
        self.year.to_s + '年度 ' + self.name.to_s +  "（NISA口座）"
      when 2
        self.year.to_s + '年度 ' + self.name.to_s +  "（ジュニアNISA口座）"
      when 3
        self.name.to_s +  "（特定口座）"
      when 4
        self.name.to_s +  "（一般口座）"
    end
  end
end
