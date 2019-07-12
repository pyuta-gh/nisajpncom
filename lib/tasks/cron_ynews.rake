#ニュース情報のデータ反映
namespace :cron do           # ネームスペースを定義 "rake cron: ..."となる
  require 'open-uri'
  require "csv"
  require 'rss'
  # rake cron:newsで実行
  desc "ニュース情報"    # rake -T のタスク一覧の結果で表示されるタスクの説明文
  task news: :environment do # タスク名を定義
    puts "[" +Time.now.to_s + "][cron:news]Process START"
    #営業日のみ処理対象
    if (Calender.where('opt=001 and holliday =?',Date.today).all.records.count == 0 and Date.today.wday !=0 and Date.today.wday !=6) or Rails.env == 'development'
      rss_sources = Array[
          Array["Y! ファイナンス","http://news.finance.yahoo.co.jp/rss/stocks.xml"],
          Array["Y! ファイナンス","http://news.finance.yahoo.co.jp/rss/world.xml"]
      ]

      #テーブルに反映
      Topic.transaction do
        for rss_source in rss_sources do
          begin
            rss = RSS::Parser.parse(rss_source[1], true)
          rescue RSS::Error
          end
          #データ登録
          rss.items.each do |item|
            topic=Topic.new
            topic.pubDate=item.pubDate
            topic.title=item.title
            topic.link=item.link
            topic.category="Y! ファイナンス "+item.category.content
            topic.save!
            #raise ActiveRecord::Rollback
          end
        end
      end
    end
    puts "["+Time.now.to_s + "][cron:news]Process END"
  end
end

