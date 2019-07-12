class WelcomeController < ApplicationController
  before_action :sign_in_required

  def index
    if Bank.joins("INNER JOIN stock_holds ON stock_holds.bank_id = banks.id and stock_holds.user_id = banks.user_id")
           .where("banks.user_id = "  + current_user.id.to_s + " and banks.opt in(1,2) and expire_flg = true and stock_holds.sell_quantity is null").records.count >0
      flash[:notice] = "NISA口座の保有銘柄の中に、NISAの有効期間切れの登録銘柄があります。<br>NISAの有効期間内に譲渡するか、口座種類をNISA口座、ジュニアNISAから一般口座、特定口座に変更ください。".html_safe

    end

    #@bank_count = Bank.where("user_id = "  + current_user.id.to_s + " and banks.opt in(1,2) ").records.count
    @bank_count = Bank.where("user_id = "  + current_user.id.to_s ).records.count

    #グラフ_年度別NISA取得金額（直近5年分）
    @graph_nisa_year_buy =SystemCode.where("system_codes.opt = '001' and system_codes.key <=? and system_codes.key >=(?)",Date.today.year,Date.today.year-4)
                               .joins("LEFT JOIN banks on system_codes.key = banks.year"+ " and banks.user_id = "  +current_user.id.to_s + " and banks.opt in(1,2) and banks.expire_flg =false")
                               .joins("LEFT JOIN stock_holds ON stock_holds.bank_id = banks.id and stock_holds.user_id = banks.user_id")
                               .select("system_codes.key as bank_year,sum((stock_holds.buy_rate_mny * stock_holds.buy_quantity)) as hold_total").group(:bank_year).order("bank_year ASC")

    #グラフ_年度別NISA保有金額（直近5年分）
    @graph_nisa_year_hold =SystemCode.where("system_codes.opt = '001' and system_codes.key <=? and system_codes.key >=(?)",Date.today.year,Date.today.year-4)
                              .joins("LEFT JOIN banks on system_codes.key = banks.year"+ " and banks.user_id = "  +current_user.id.to_s + " and banks.opt in(1,2) and banks.expire_flg =false")
                              .joins("LEFT JOIN stock_holds ON stock_holds.bank_id = banks.id and stock_holds.user_id = banks.user_id and sell_quantity is null")
                              .select("system_codes.key as bank_year,sum((stock_holds.buy_rate_mny * stock_holds.buy_quantity)) as hold_total").group(:bank_year).order("bank_year ASC")

    #グラフ_年度別NISA譲渡損益（直近5年分）
    @graph_nisa_year_sell =SystemCode.where("system_codes.opt = '001' and system_codes.key <=? and system_codes.key >=(?)",Date.today.year,Date.today.year-4)
                               .joins("LEFT JOIN banks on system_codes.key = banks.year"+ " and banks.user_id = "  +current_user.id.to_s + " and banks.opt in(1,2) and banks.expire_flg =false")
                               .joins("LEFT JOIN stock_holds ON stock_holds.bank_id = banks.id and stock_holds.user_id = banks.user_id and sell_quantity is not null")
                               .select("system_codes.key as bank_year,sum((stock_holds.sell_quantity * stock_holds.sell_rate_mny - stock_holds.buy_quantity * stock_holds.buy_rate_mny - COALESCE(stock_holds.expenses_mny, 0))) as profit_loss_sell").group(:bank_year).order("bank_year ASC")

    #グラフ_年度別NISA配当金額（直近5年分）
    @graph_nisa_year_dividend =SystemCode.where("system_codes.opt = '001' and system_codes.key <=? and system_codes.key >=(?)",Date.today.year,Date.today.year-4)
                                   .joins("LEFT JOIN banks on system_codes.key = banks.year"+ " and banks.user_id = "  +current_user.id.to_s + " and banks.opt in(1,2) and banks.expire_flg =false")
                                   .joins("LEFT JOIN dividends ON dividends.bank_id = banks.id and dividends.user_id = banks.user_id")
                                   .select("system_codes.key as bank_year,sum(pay_profit_mny) as pay_profit_mny_total").group(:bank_year).order("bank_year ASC")

    #NISA買付余力
    @stock_holds_buy_total = Bank.joins("INNER JOIN stock_holds ON stock_holds.bank_id = banks.id and stock_holds.user_id = banks.user_id")
                                 .joins("INNER JOIN system_codes as bank_opt on banks.opt = bank_opt.key and bank_opt.opt = '006'")
                                 .where("banks.user_id = "  +current_user.id.to_s + " and banks.opt in(1,2) ")
                                 .select("bank_opt.name as bank_opt_name,banks.year as bank_year,banks.name as bank_name,banks.opt as bank_opt,banks.expire_flg as bank_expire_flg,sum((stock_holds.buy_rate_mny * stock_holds.buy_quantity)) as hold_total").group(:bank_opt_name,:bank_year,:bank_name,:bank_opt,:bank_expire_flg).order("bank_year DESC,bank_opt_name,bank_name ASC,bank_opt ASC ")

    #NISA保有銘柄
    @stock_holds = StockHold.joins("LEFT JOIN stock_infos ON stock_infos.stock_code = stock_holds.stock_code")
                       .joins("INNER JOIN system_codes ON stock_holds.stock_type = system_codes.key and opt = '003'")
                       .joins("INNER JOIN banks ON stock_holds.bank_id = banks.id and stock_holds.user_id = banks.user_id")
                       .joins("INNER JOIN system_codes as bank_opt on banks.opt = bank_opt.key and bank_opt.opt = '006'")
                       .where("stock_holds.user_id = "  +current_user.id.to_s + " and sell_quantity is null and banks.opt in(1,2) ")
                       .select("bank_opt.name as bank_opt_name,banks.year as bank_year,banks.name as bank_name,banks.opt as bank_opt,banks.expire_flg as bank_expire_flg,stock_holds.stock_type as stock_type,system_codes.name as stock_type_name,sum((stock_holds.buy_rate_mny * stock_holds.buy_quantity)) as hold_total,sum((stock_infos.end_rate_mny * stock_holds.buy_quantity)) as current_total,sum((stock_holds.buy_quantity * COALESCE(stock_infos.end_rate_mny, 0) - stock_holds.buy_quantity * stock_holds.buy_rate_mny - COALESCE(stock_holds.expenses_mny, 0))) as profit_loss_current,sum(if((ifnull(stock_infos.stock_code,1))=1,1,0)) as stock_info_null_cnt").group(:bank_opt_name,:bank_year,:bank_name,:bank_opt,:stock_type,:stock_type_name,:bank_expire_flg).order("bank_year DESC,bank_opt_name,bank_name ASC,bank_opt ASC ")

    #NISA譲渡銘柄
    @stock_profit_loss = StockHold.joins("LEFT JOIN stock_infos ON stock_infos.stock_code = stock_holds.stock_code")
                       .joins("INNER JOIN system_codes ON stock_holds.stock_type = system_codes.key and opt = '003'")
                       .joins("INNER JOIN banks ON stock_holds.bank_id = banks.id and stock_holds.user_id = banks.user_id")
                       .joins("INNER JOIN system_codes as bank_opt ON banks.opt = bank_opt.key and bank_opt.opt = '006'")
                       .where("stock_holds.user_id = "  +current_user.id.to_s + " and sell_quantity is not null and banks.opt in(1,2) ")
                       .select("bank_opt.name as bank_opt_name,banks.year as bank_year,banks.name as bank_name,banks.opt as bank_opt,banks.expire_flg as bank_expire_flg,stock_holds.stock_type as stock_type,system_codes.name as stock_type_name,sum((stock_holds.buy_rate_mny * stock_holds.buy_quantity)) as hold_total,sum((stock_holds.sell_rate_mny * stock_holds.sell_quantity)) as sell_total,sum(COALESCE(stock_holds.expenses_mny, 0)) as expenses_mny,sum((stock_holds.sell_quantity * stock_holds.sell_rate_mny - stock_holds.buy_quantity * stock_holds.buy_rate_mny - COALESCE(stock_holds.expenses_mny, 0))) as profit_loss_sell").group(:bank_opt_name,:bank_year,:bank_name,:bank_opt,:stock_type,:stock_type_name,:bank_expire_flg).order("bank_year DESC,bank_opt_name,bank_name ASC,bank_opt ASC ")
    #NISA配当金額
    @dividends  = User.joins(:banks).where("banks.opt in(1,2) and users.id =?",current_user.id)
                      .joins("INNER JOIN dividends on  banks.id = dividends.bank_id and  banks.user_id = dividends.user_id")
                      .joins("INNER JOIN system_codes as stock_type_name ON dividends.stock_type = stock_type_name.key and stock_type_name.opt = '003'")
                      .joins("INNER JOIN system_codes as bank_opt_name ON banks.opt = bank_opt_name.key and bank_opt_name.opt = '006'")
                      .select("banks.year as bank_year,banks.name as bank_name ,bank_opt_name.name as bank_opt_name,stock_type_name.name as stock_type_name,sum(dividends.pay_profit_mny) as pay_profit_mny_total")
                      .group(:bank_opt_name,:bank_year,:bank_name,:stock_type_name)
                      .order("bank_year DESC,bank_opt_name,bank_name ASC,stock_type_name ASC ")

    #一般、特定保有銘柄
    @stock_holds_3_4 = StockHold.joins("LEFT JOIN stock_infos ON stock_infos.stock_code = stock_holds.stock_code")
                       .joins("INNER JOIN system_codes ON stock_holds.stock_type = system_codes.key and opt = '003'")
                       .joins("INNER JOIN banks ON stock_holds.bank_id = banks.id and stock_holds.user_id = banks.user_id")
                       .joins("INNER JOIN system_codes as bank_opt on banks.opt = bank_opt.key and bank_opt.opt = '006'")
                       .where("stock_holds.user_id = "  +current_user.id.to_s + " and sell_quantity is null and banks.opt in(3,4) ")
                       .select("bank_opt.name as bank_opt_name,banks.year as bank_year,banks.name as bank_name,banks.opt as bank_opt,stock_holds.stock_type as stock_type,system_codes.name as stock_type_name,sum((stock_holds.buy_rate_mny * stock_holds.buy_quantity)) as hold_total,sum((stock_infos.end_rate_mny * stock_holds.buy_quantity)) as current_total,sum((stock_holds.buy_quantity * COALESCE(stock_infos.end_rate_mny, 0) - stock_holds.buy_quantity * stock_holds.buy_rate_mny - COALESCE(stock_holds.expenses_mny, 0))) as profit_loss_current,sum(if((ifnull(stock_infos.stock_code,1))=1,1,0)) as stock_info_null_cnt").group(:bank_opt_name,:bank_year,:bank_name,:bank_opt,:stock_type,:stock_type_name).order("bank_year DESC,bank_opt_name,bank_name ASC,bank_opt ASC ")

    #一般、特定譲渡銘柄
    @stock_profit_loss_3_4 = StockHold.joins("LEFT JOIN stock_infos ON stock_infos.stock_code = stock_holds.stock_code")
                             .joins("INNER JOIN system_codes ON stock_holds.stock_type = system_codes.key and opt = '003'")
                             .joins("INNER JOIN banks ON stock_holds.bank_id = banks.id and stock_holds.user_id = banks.user_id")
                             .joins("INNER JOIN system_codes as bank_opt ON banks.opt = bank_opt.key and bank_opt.opt = '006'")
                             .where("stock_holds.user_id = "  +current_user.id.to_s + " and sell_quantity is not null and banks.opt in(3,4) ")
                             .select("bank_opt.name as bank_opt_name,banks.year as bank_year,banks.name as bank_name,banks.opt as bank_opt,stock_holds.stock_type as stock_type,system_codes.name as stock_type_name,sum((stock_holds.buy_rate_mny * stock_holds.buy_quantity)) as hold_total,sum((stock_holds.sell_rate_mny * stock_holds.sell_quantity)) as sell_total,sum(COALESCE(stock_holds.expenses_mny, 0)) as expenses_mny,sum((stock_holds.sell_quantity * stock_holds.sell_rate_mny - stock_holds.buy_quantity * stock_holds.buy_rate_mny - COALESCE(stock_holds.expenses_mny, 0))) as profit_loss_sell").group(:bank_opt_name,:bank_year,:bank_name,:bank_opt,:stock_type,:stock_type_name).order("bank_year DESC,bank_opt_name,bank_name ASC,bank_opt ASC ")

    #NISA配当金額
    @dividends_3_4  = User.joins(:banks).where("banks.opt in(3,4) and users.id =?",current_user.id)
                      .joins("INNER JOIN dividends on  banks.id = dividends.bank_id and  banks.user_id = dividends.user_id")
                      .joins("INNER JOIN system_codes as stock_type_name ON dividends.stock_type = stock_type_name.key and stock_type_name.opt = '003'")
                      .joins("INNER JOIN system_codes as bank_opt_name ON banks.opt = bank_opt_name.key and bank_opt_name.opt = '006'")
                      .select("banks.year as bank_year,banks.name as bank_name ,bank_opt_name.name as bank_opt_name,stock_type_name.name as stock_type_name,sum(dividends.pay_profit_mny)  as pay_profit_mny_total")
                      .group(:bank_opt_name,:bank_year,:bank_name,:stock_type_name)
                      .order("bank_year DESC,bank_opt_name,bank_name ASC,stock_type_name ASC ")

  end
end
