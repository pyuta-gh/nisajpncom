#銘柄異動情報の反映
namespace :cron do           # ネームスペースを定義 "rake cron: ..."となる
  # rake cron:stock_changeで実行
  desc "銘柄異動情報"    # rake -T のタスク一覧の結果で表示されるタスクの説明文
  task stock_change: :environment do # タスク名を定義
    puts "[" +Time.now.to_s + "][cron:stock_change]Process START"
    #営業日のみ処理対象
    if (Calender.where('opt=001 and holliday =?',Date.today).all.records.count == 0 and Date.today.wday !=0 and Date.today.wday !=6) or Rails.env == 'development'
      #株価異動情報を取得
      change = (StockInfoChange.joins("INNER JOIN stock_holds on stock_info_changes.stock_code=stock_holds.stock_code  INNER JOIN stock_infos on stock_info_changes.stock_code=stock_infos.stock_code  inner join users on stock_holds.user_id= users.id")).where("mail_send=false and target_date<=? and stock_holds.sell_date is null",Date.today)
                   .select("users.email,stock_infos.stock_code,stock_infos.stock_name,stock_infos.end_rate_mny,stock_info_changes.change_type,stock_info_changes.stock_message,stock_info_changes.target_date")

      #テーブルに反映
      StockInfoChangeMail.transaction do
        #既存データ削除
        StockInfoChangeMail.destroy_all
        #シーケンスリセット
        ActiveRecord::Base.connection.execute('ALTER TABLE stock_info_change_mails AUTO_INCREMENT = 1')
        #株価異動情報のメール送信データ登録
        change.each do |rec|
          stcok_info_change_mail =StockInfoChangeMail.new
          stcok_info_change_mail.email=rec.email
          stcok_info_change_mail.stock_code=rec.stock_code
          stcok_info_change_mail.stock_name=rec.stock_name
          stcok_info_change_mail.end_rate_mny=rec.end_rate_mny
          stcok_info_change_mail.change_type=rec.change_type
          stcok_info_change_mail.stock_message=rec.stock_message
          stcok_info_change_mail.target_date=rec.target_date
          stcok_info_change_mail.save!
        end
      end

      #メール送信
      #メール送信フラグ trueと株価異動情報テーブルにデータがあるものが対象
      stcok_info_change_mail=StockInfoChangeMail.select("email").group("email")
      stcok_info_change_mail.each do |rec_user|
        inquiry = Inquiry.new
        inquiry.email=rec_user.email
        InquiryMailer.send_email_stock_info_change(inquiry,"[ニーサジャパン.com]保有銘柄の株式の情報をお知らせします").deliver
      end

      #メール送信後、送信済みフラグを更新
      StockInfoChange.where("mail_send=false and target_date<=?",Date.today).update_all(:mail_send => true)
    end
    puts "["+Time.now.to_s + "][cron:stock_change]Process END"
  end
end

