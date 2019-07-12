module ApplicationHelper
  def is_numeric?(str)
    Integer(str)
    true
  rescue ArgumentError
    false
  end
  def format_num(str,opt)
    str=str.to_s
    if str.to_s != "" and is_numeric?(str)
      case opt
        when Settings.format_opt.currency
          format_opt = Settings.format_opt.currency
        when Settings.format_opt.quantity
          format_opt = Settings.format_opt.quantity
        when Settings.format_opt.count
          format_opt = Settings.format_opt.count
        else
          format_opt = ""
      end

      return number_to_currency(str, unit: '', precision: 0).to_s + format_opt
    else
      return ""
    end
  end
  #少数のフォーマット
  def format_decimal(str,opt,num)
    str=str.to_s
    if str.to_s != ""
      case opt
        when Settings.format_opt.currency
          format_opt = Settings.format_opt.currency
        when Settings.format_opt.quantity
          format_opt = Settings.format_opt.quantity
        when Settings.format_opt.count
          format_opt = Settings.format_opt.count
        else
          format_opt = ""
      end

      return number_to_currency(str, unit: '', precision: num).to_s + format_opt
    else
      return ""
    end
  end
  def format_bool(str,opt)

    if str == false or str == true
      if str==true
        return "○"
      else
        return "×"
      end
    else
      return ""
    end
  end
end
