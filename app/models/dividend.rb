#配当金
class Dividend < ApplicationRecord
  #結合
  belongs_to :user
  belongs_to :bank

  #必須チェック
  validates :stock_type, presence: true
  validates :pay_date, presence: true
  validates :pay_profit_mny, presence: true
  validates :bank_id, presence: true

  #半角数字チェック
  validates :pay_rate_mny, numericality: { greater_than_or_equal_to: 0.01,less_than_or_equal_to:9999999, allow_blank: true}
  validates :pay_quantity, numericality: {only_integer: true, greater_than: 0,less_than_or_equal_to:99999999, allow_blank: true}
  validates :pay_profit_mny, numericality: {only_integer: true, greater_than: 0,less_than_or_equal_to:99999999, allow_blank: true}

  #銘柄コードチェック
  validates :stock_code, numericality: {
                           only_integer: true, greater_than_or_equal_to: 1000,less_than_or_equal_to:9999,allow_blank: true
                       }

  #日付チェック
  validates_datetime :pay_date

  #株式分類チェック
  validate :stock_type_chk
  def stock_type_chk
    if !(stock_type == Settings.stock_type.jpn_stock  or stock_type == Settings.stock_type.investment  or stock_type == Settings.stock_type.foreign_stock or stock_type == Settings.stock_type.other)
      errors.add(:stock_type,"の入力に誤りがあります")
    end
  end

  #銘柄名の手入力は国内株式以外は必須（外国株式、投資信託、Reit）チェック
  validate :stock_name_chk
  def stock_name_chk
    if errors.count==0
      if stock_type == Settings.stock_type.jpn_stock
        if stock_code.to_s==""
          errors.add(:stock_code,"を入力してください。")
        elsif !StockInfo.exists?(stock_code: stock_code)
          errors.add(:stock_code, "は存在する値を入力してください")
        end
      else
        if stock_name.to_s==""
          errors.add(:stock_name,"は国内株式以外は入力してください")
        end
      end
    end
  end

  #NISA年度の有効期限を超える譲渡年度はエラーチェック
  validate :pay_nisa_expire
  def pay_nisa_expire
    if errors.count==0 && !pay_date.nil?
      bank = Bank.where("user_id = '"  + user_id.to_s + "' and id ='"+ bank_id.to_s  + "'").first
      if (bank.opt ==1 or bank.opt ==2) && bank.expire_flg == true
        #取得年度からXX年より、大きい譲渡年度はエラー
        if (bank.year.to_i + Settings.nisa.expire_years.to_i ) <= pay_date.year
          errors.add(:pay_date,"は、NISA口座の有効期間を超える入金日は入力できません")
        end
      end
    end
  end

  #単価×数量＝配当金額（誤差１０円以内）チェック
  validate :pay_profit_mny_check
  def pay_profit_mny_check
    if errors.count==0
      if !pay_rate_mny.nil? && !pay_quantity.nil? && !pay_profit_mny.nil?
        #単価×数量≠配当金額はチェックNG
        wk_calc = (pay_rate_mny * pay_quantity - pay_profit_mny).abs
        if wk_calc > 10
          errors.add(:pay_profit_mny,"は、単価×数量と一致していません（10円以上の誤差はエラー）")
        end
      end
    end
  end

  #配当金が１千万円を超える場合、上限エラー
  validate :pay_profit_range_check
  def pay_profit_range_check
    if errors.count==0
      if !pay_rate_mny.nil? && !pay_quantity.nil?
        if  (pay_rate_mny * pay_quantity)>=10000000
          errors.add(:pay_rate_mny,"単価×数量の金額が上限１千万円以内で入力してください")
        end
      end
    end
  end

  #入金年度はNISA年度と異なる場合はエラー、入金日は未来日はエラーチェック
  validate :pay_date_range
  def pay_date_range
    bank = Bank.where("user_id = '"  + user_id.to_s + "'").find_by_id(bank_id)
    if !bank.nil? and (bank.opt ==1 or bank.opt ==2)
      if pay_date.to_s[0,4]<bank.year.to_s
        errors.add(:pay_date,"は口座分類の" + bank.year.to_s + "年度以降を入力してください")
      elsif pay_date >Date.today
        errors.add(:pay_date,"は未来日は入力できません")
      end
    end
  end

end
