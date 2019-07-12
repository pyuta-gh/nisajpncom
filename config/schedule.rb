set :output, 'log/crontab.log'
set :environment, :development

#/bin/bash: bundle: command not found エラー回避用にrbenv、PATH初期化
env :PATH, ENV['PATH']
job_type :rbenv_rake, %q!eval "$(rbenv init -)"; cd :path && :environment_variable=:environment bundle exec rake :task --silent :output!

#株価データのダウンロード
every 1.day, at: '18:00 pm' do
  rake "cron:stock"
end

#株価ウオッチリスト
every 1.day, at: '18:20 pm' do
  rake "cron:smonitor"
end

#cron 設定の確認
#bundle exec crontab -e

#cron 設定実行
#whenever を実行する環境を指定し反映
#whenever はデフォルトでは environment に production を指定するが、 development など他の環境で動かすには以下のようにコマンドを実行する。
#bundle exec whenever --update-crontab

#cron 設定削除
#bundle exec whenever --clear-crontab

