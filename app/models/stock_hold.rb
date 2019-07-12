#保有銘柄
class StockHold < ApplicationRecord
  #結合
  belongs_to :user
  belongs_to :bank

  # クラス変数
  #cattr_accessor :skip_buy_limit_over

  #共通 正規表現
  include RegexValidators

  #必須チェック
  validates :stock_type, presence: true
  validates :buy_date, presence: true
  validates :buy_rate_mny, presence: true
  validates :buy_quantity, presence: true
  validates :bank_id, presence: true

  #半角数字チェック
  validates :buy_rate_mny, numericality: {only_integer: true, greater_than: 0,less_than_or_equal_to:9999999}
  validates :buy_quantity, numericality: {only_integer: true, greater_than: 0,less_than_or_equal_to:99999999}
  validates :sell_rate_mny, numericality: {only_integer: true, greater_than: 0,less_than_or_equal_to:9999999, allow_blank: true}
  validates :sell_quantity, numericality: {only_integer: true, greater_than: 0,less_than_or_equal_to:99999999, allow_blank: true}
  validates :expenses_mny, numericality: {only_integer: true, greater_than: 0,less_than_or_equal_to:999999, allow_blank: true}

  #銘柄コードチェック
  validates :stock_code, numericality: {
                             only_integer: true, greater_than_or_equal_to: 1000,less_than_or_equal_to:9999,allow_blank: true
                       }

  #株式分類チェック
  validate :stock_type_chk
  def stock_type_chk
    if !(stock_type == Settings.stock_type.jpn_stock  or stock_type == Settings.stock_type.investment  or stock_type == Settings.stock_type.foreign_stock or stock_type == Settings.stock_type.other)
      errors.add(:stock_type,"の入力に誤りがあります")
    end
  end

  #日付チェック
  validates_datetime :buy_date , allow_blank: true
  validates_datetime :sell_date , allow_blank: true

  #譲渡日、譲渡数、譲渡単価はセット入力チェック
  validate :sell_rate_quantity_mny
  def sell_rate_quantity_mny
    if !sell_rate_mny.nil? or !sell_quantity.nil? or !sell_date.nil?
      if sell_rate_mny.nil?
        errors.add(:sell_rate_mny,"を入力してください")
      elsif sell_quantity.nil?
        errors.add(:sell_quantity,"を入力してください")
      elsif  sell_date.nil?
        errors.add(:sell_date,"を入力してください")
      end
    end
  end

  #譲渡日は取得日より前はエラーチェック
  validate :sell_date_range
  def sell_date_range
    if (!sell_date.nil? and !buy_date.nil?)
      if sell_date  < buy_date
        errors.add(:sell_date,"は取得日以降を入力してください")
      elsif sell_date >Date.today
        errors.add(:sell_date,"は未来日は入力できません")
      end
    end
  end

  #取得年度はNISA年度と異なる場合はエラー、取得日は未来日はエラーチェック
  validate :buy_date_range
  def buy_date_range
    bank = Bank.where("user_id = '"  + user_id.to_s + "'").find_by_id(bank_id)
    if !bank.nil? and (bank.opt ==1 or bank.opt ==2)
      if buy_date.to_s[0,4]!=bank.year.to_s
        errors.add(:buy_date,"は口座分類の" + bank.year.to_s + "年度で入力してください")
      elsif buy_date >Date.today
          errors.add(:buy_date,"は未来日は入力できません")
      end
    end
  end

  #取得株数より、譲渡株数が多い場合、エラーチェック
  validate :sell_quantity_range
  def sell_quantity_range
    if !buy_quantity.nil? and !sell_quantity.nil?
      if buy_quantity < sell_quantity
        errors.add(:sell_quantity,"は取得株数以下を入力してください")
      end
    end
  end

  #銘柄名の手入力は国内株式以外は必須（外国株式、投資信託、Reit）
  validate :stock_name_chk
  def stock_name_chk
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

  #新規登録時、取得株数と譲渡株数は同一のみチェック
  validate :buy_sell_quantity_chk, on: :create
  def buy_sell_quantity_chk
    if !buy_quantity.nil? and !sell_quantity.nil?
      if buy_quantity != sell_quantity
        errors.add(:buy_quantity,"は、譲渡の新規登録のため、譲渡株数と同じ値を入力してください")
        errors.add(:sell_quantity,"は、譲渡の新規登録のため、取得株数と同じ値を入力してください")
      end
    end
  end

  #NISA年度の有効期限を超える譲渡年度はエラーチェック
  validate :sell_nisa_expire
  def sell_nisa_expire
    if errors.count==0 && !sell_date.nil?
      bank = Bank.where("user_id = '"  + user_id.to_s + "' and id ='"+ bank_id.to_s  + "'").first
      if (bank.opt ==1 or bank.opt ==2) && bank.expire_flg == true
        #取得年度からXX年より、大きい譲渡年度はエラー
        if (buy_date.year.to_i + Settings.nisa.expire_years.to_i ) <= sell_date.year
          errors.add(:sell_date,"は、NISA口座の有効期間を超える譲渡日は入力できません")
        end
      end
    end
  end

  #NISA年度の余力超の取得金額はエラーチェック
  validate :buy_nisa_limit_over
  def buy_nisa_limit_over
    if errors.count==0
      #一部譲渡の場合は、チェック対象外
      #if skip_buy_limit_over!=true
        buy_sum = StockHold.where("user_id = '"  + user_id.to_s + "' and bank_id ='"+ bank_id.to_s  + "'" + " and id <> '" + id.to_s + "'").select("sum(buy_rate_mny * buy_quantity) as total, bank_id").group(:bank_id).order(nil)
        if buy_sum.records.count ==0 or buy_sum.nil?
          total = 0 + buy_rate_mny * buy_quantity
        else
          total = buy_sum.first.total + buy_rate_mny * buy_quantity
        end

        bank = Bank.where("user_id = '"  + user_id.to_s + "' and id ='"+ bank_id.to_s  + "'")

        #2014-2015は余力１００万円
        #2016-    は余力１２０万円
        #2016-    ジュニアは余力８０万円
        if bank.first.opt ==1 or bank.first.opt ==2
          case bank.first.year
            when 2014,2015
              if bank.first.opt == 1 && total>1000000
                errors[:base] <<"取得金額合計がNISAの買付上限[1,000,000円]を超えてます"
              end
            else
              if bank.first.year>=2016 && bank.first.opt == 2
                if total>800000
                  errors[:base] <<"取得金額合計がNISAの買付上限[800,000円]を超えてます"
                end
              else
                if bank.first.year>=2016 && bank.first.opt == 1 && total>1200000
                  errors[:base] <<"取得金額合計がNISAの買付上限[1,200,000円]を超えてます"
                end
              end
          end
        end
      #else
      #  skip_buy_limit_over = nil
      #end
    end
  end

  #取得金額が１億を超える場合、上限エラーチェック
  validate :buy_range_check
  def buy_range_check
    if errors.count==0
      if !buy_rate_mny.nil? && !buy_quantity.nil?
        if  (buy_rate_mny * buy_quantity)>=100000000
          errors.add(:buy_rate_mny,"取得単価×取得数量の金額が上限１億円以内で入力してください")
        end
      end
    end
  end

  #譲渡金額が１億を超える場合、上限エラーチェック
  validate :sell_range_check
  def sell_range_check
    if errors.count==0
      if !sell_rate_mny.nil? && !sell_quantity.nil?
        if  (sell_rate_mny * sell_quantity)>=100000000
          errors.add(:sell_rate_mny,"譲渡単価×譲渡数量の金額が上限１億円以内で入力してください")
        end
      end
    end
  end
end
