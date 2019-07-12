#ウオッチリストメール送信
namespace :cron do           # ネームスペースを定義 "rake cron: ..."となる
  # rake cron:smonitorで実行
  desc "ウオッチリストメール送信"    # rake -T のタスク一覧の結果で表示されるタスクの説明文
  task smonitor: :environment do # タスク名を定義
    puts "[" +Time.now.to_s + "][cron:smonitor]Process START"
    #営業日のみ処理対象
    if (Calender.where('opt=001 and holliday =?',Date.today).all.records.count == 0 and Date.today.wday !=0 and Date.today.wday !=6) or Rails.env == 'development'
      #安値、高値がウオッチ価格より大きい場合
      higher = User.joins(:stock_monitors)
                   .joins("INNER JOIN stock_infos on stock_monitors.stock_code=stock_infos.stock_code where  mail_enabled = true and monitor_type=1  and (stock_monitors.value < stock_infos.min_rate_mny or stock_monitors.value < stock_infos.max_rate_mny)")
                   .select("stock_monitors.monitor_type,users.email,stock_monitors.stock_code,stock_infos.min_rate_mny,stock_infos.max_rate_mny,stock_infos.end_rate_mny,stock_monitors.value as monitor_mny,stock_infos.stock_name")

      #安値、高値がウオッチ価格より小さい場合
      lower =User.joins(:stock_monitors)
                 .joins("INNER JOIN stock_infos on stock_monitors.stock_code=stock_infos.stock_code where  mail_enabled = true and monitor_type=2  and (stock_monitors.value > stock_infos.min_rate_mny or stock_monitors.value > stock_infos.max_rate_mny)")
                 .select("stock_monitors.monitor_type,users.email,stock_monitors.stock_code,stock_infos.min_rate_mny,stock_infos.max_rate_mny,stock_infos.end_rate_mny,stock_monitors.value as monitor_mny,stock_infos.stock_name")

      #テーブルに反映
      StockMonitorMail.transaction do
        #既存データ削除
        StockMonitorMail.destroy_all
        #シーケンスリセット
        ActiveRecord::Base.connection.execute('ALTER TABLE stock_monitor_mails AUTO_INCREMENT = 1')

        #ウオッチ価格オーバーのメール送信データ作成
        higher.each do |rec|
          stock_monitor_mail=StockMonitorMail.new
          stock_monitor_mail.email = rec.email
          stock_monitor_mail.monitor_type = rec.monitor_type
          stock_monitor_mail.monitor_mny = rec.monitor_mny
          stock_monitor_mail.stock_code = rec.stock_code
          stock_monitor_mail.stock_name = rec.stock_name
          stock_monitor_mail.min_rate_mny = rec.min_rate_mny
          stock_monitor_mail.max_rate_mny = rec.max_rate_mny
          stock_monitor_mail.end_rate_mny = rec.end_rate_mny
          stock_monitor_mail.monitor_mny = rec.monitor_mny
          stock_monitor_mail.save!
        end

        #ウオッチ価格下回りのメール送信データ作成
        lower.each do |rec|
          stock_monitor_mail=StockMonitorMail.new
          stock_monitor_mail.email = rec.email
          stock_monitor_mail.monitor_type = rec.monitor_type
          stock_monitor_mail.monitor_mny = rec.monitor_mny
          stock_monitor_mail.stock_code = rec.stock_code
          stock_monitor_mail.stock_name = rec.stock_name
          stock_monitor_mail.min_rate_mny = rec.min_rate_mny
          stock_monitor_mail.max_rate_mny = rec.max_rate_mny
          stock_monitor_mail.end_rate_mny = rec.end_rate_mny
          stock_monitor_mail.monitor_mny = rec.monitor_mny
          stock_monitor_mail.save!
        end
      end

      #メール送信実行
      stock_monitor_mail=StockMonitorMail.select("email").group("email")
      stock_monitor_mail.each do |rec_user|
        inquiry = Inquiry.new
        inquiry.email=rec_user.email
        InquiryMailer.send_email_stock(inquiry,"[ニーサジャパン.com]ウオッチリスト銘柄の条件に該当する値動きがありました").deliver
      end
    end
    puts "["+Time.now.to_s + "][cron:smonitor]Process END"
  end
end

