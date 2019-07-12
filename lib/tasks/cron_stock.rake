#個別株価情報のデータ反映
namespace :cron do           # ネームスペースを定義 "rake cron: ..."となる
  require 'open-uri'
  require "csv"

  # rake cron:stockで実行
  desc "個別株価情報"    # rake -T のタスク一覧の結果で表示されるタスクの説明文
  task stock: :environment do # タスク名を定義
    puts "[" +Time.now.to_s + "][cron:stock]Process START"
    #営業日のみ処理対象
    #if (Calender.where('opt=001 and holliday =?',Date.today).all.records.count == 0 and Date.today.wday !=0 and Date.today.wday !=6) or Rails.env == 'development'
      #CSVダウンロード
      #open("./public/data/stock.csv", 'wb') do |output|
      #  open("http://k-db.com/stocks/?download=csv") do |data|
      #    output.write(data.read)
      #  end
      #end
      #csv_data  = CSV.read('./public/data/stock.csv',headers: true)
      csv_data  = CSV.read('./public/data/history/stock_2017-12-31_180110.csv',headers: true)

      #テーブルに反映
      StockInfo.transaction do
        #既存データ削除
        StockInfo.destroy_all
        #シーケンスリセット
        ActiveRecord::Base.connection.execute('ALTER TABLE stock_infos AUTO_INCREMENT = 1')

        #CSV読み込みデータ登録
        csv_data.each do |data|
          #有効なデータのみ対象
          if !data[6].nil? and data[0][4,1].to_s=="-"

            stockinfo=StockInfo.new

            #市場データ編集
            case  true
              when data[2].to_s.include?("JQ") then
                # JQグロース
                # JQスタンダード
                # JQスタンダード外国
                stockinfo.market_code="JQ"
              when data[2].to_s.include?("札証") then
                # 札証
                # 札証アンビシャス
                stockinfo.market_code="SP"
              when data[2].to_s.include?("マザーズ") then
                # 東証マザーズ
                # 東証マザーズ外国
                stockinfo.market_code="MZ"
              when data[2].to_s.include?("福証") then
                # 福証
                # 福証Q-Board
                stockinfo.market_code="FK"
              when data[2].to_s.include?("東証1部") then
                # 東証1部
                # 東証1部外国
                stockinfo.market_code="TS1"
              when data[2].to_s.include?("東証2部") then
                # 東証2部
                # 東証2部外国
                stockinfo.market_code="TS2"
              when data[2].to_s.include?("東証") then
                # 東証
                stockinfo.market_code="TS"
              else
                break
            end
            stockinfo.stock_code       =  data[0][0,4].to_s
            stockinfo.stock_name       =  data[1].to_s
            stockinfo.end_rate_mny =  data[6].to_i
            stockinfo.min_rate_mny= data[5].to_i
            stockinfo.max_rate_mny= data[4].to_i
            stockinfo.start_rate_mny= data[3].to_i
            stockinfo.buy_sell_quantity= data[7].to_i
            stockinfo.trading_sum_mny= data[8].to_i

            #登録
            stockinfo.save!
            #raise ActiveRecord::Rollback
          end
        end

        #複数市場の上場は、売買代金が少ないものを削除（売買代金が高いものを優先市場として登録）
        stock_info_dubble=StockInfo.select("stock_code,count(stock_code),max(id) as max_id").group(:stock_code).having('count(stock_code) > ?', 1)
        stock_info_dubble.each do |rec|
          #削除
          StockInfo.where("stock_code =? and id <>?",rec.stock_code,rec.max_id).destroy_all
        end
      end

      #データ登録後、CSV退避
      File.rename("./public/data/stock.csv", "./public/data/history/stock_" + Time.now.strftime("%Y-%m-%d_%H%M%S")+".csv" )
    #end
    puts "["+Time.now.to_s + "][cron:stock]Process END"
  end
end
