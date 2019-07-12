class InquiryMailer < ActionMailer::Base
  default from: "info@nisa.jpn.com"   # 送信元アドレス
  default to: "mail address"  # 送信先アドレス

  #お問い合わせの連絡メール送信
  def received_email(inquiry)
    @inquiry = inquiry
    mail(:subject => '【ニーサジャパン.com】お問い合わせを承りました')
  end

  #ウオッチリストのメール送信
  def send_email_stock(inquiry,subject)
    @inquiry = inquiry
    @higher = StockMonitorMail.where("email = '"  + inquiry.email + "' and monitor_type =1").order("stock_code")
    @lower  = StockMonitorMail.where("email = '"  + inquiry.email + "' and monitor_type =2").order("stock_code")
    mail to: inquiry.email, subject: subject
  end

  #株価異動情報のメール送信
  def send_email_stock_info_change(inquiry,subject)
    @inquiry = inquiry
    @change = StockInfoChangeMail.where("email = '"  + inquiry.email + "'").order("stock_code,change_type")
    mail to: inquiry.email, subject: subject
  end
end
