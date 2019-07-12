#共通正規表現チェック
module RegexValidators
  extend ActiveSupport::Concern

  #パスワード英数字混在
  REGEX_ALPHA_NUM_HALF_SYMBOL =  /([0-9].*[a-zA-Z]|[a-zA-Z].*[0-9])/
  #validates :login_password, format: { with: REGEX_ALPHA_NUM_HALF_SYMBOL,:message => "は７文字以上の英数混在で入力してください。"  }

  #半角英字
  REGEX_ALPHA_HALF = /\A[a-zA-Z]+\z/
  #validates :xxxxxxx, format: { with: REGEX_ALPHA_HALF,:message => "は半角英字で入力してください"  }

  #全角
  REGEX_ZENKAKU = /\A(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+\z/
  #validates :xxxxxxx, format: { with: REGEX_ZENKAKU,:message => "は全角で入力してください"  }

  #半角英数字
  REGEX_ALPHA_NUM_HALF = /\A[a-z0-9]+\z/i
  #validates :user_id, format: { with: REGEX_ALPHA_NUM_HALF,:message => "は半角英数字で入力してください"  }

  #メールアドレス
  REGEX_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #validates :mail, presence: true, format: { with: REGEX_EMAIL }

  #日付チェック
  def date_valid?(coulum,date)
    return if date.blank?
    # YYMMDD取得
    y = date[1].to_i
    m = date[2].to_i
    d = date[3].to_i
    unless Date.valid_date?(y, m, d)
      errors.add(coulum, "は正しい日付で入力してください")
      false
    else
      if (Date.new(y,m,d)-Date.today()).to_i >0
        errors.add(coulum, "は過去日で入力してください")
        false
      end
    end
  end

  #日時チェック
  def date_time_valid?(coulum,datetime)
    return if datetime.blank?
    # YYMMDD取得
    y = datetime[1].to_i
    m = datetime[2].to_i
    d = datetime[3].to_i
    unless Date.valid_date?(y, m, d)
      errors.add(coulum, "は正しい日付で入力してください")
      false
    else
      if (Date.new(y,m,d)-Date.today()).to_i >0
        errors.add(coulum, "は過去日で入力してください")
        false
      else
        #書式チェック
        unless format("%02d", datetime[4])+':'+format("%02d", datetime[5]) =~ /^([0-1][0-9]|[2][0-3]):[0-5][0-9]$/
          errors.add(coulum, "を正しい形式で入力してください。")
          false
        end
      end
    end
  end

end