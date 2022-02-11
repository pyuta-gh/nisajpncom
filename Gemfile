source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.2'
# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
gem 'mysql2'
# Use Puma as the app server
gem 'puma', '~> 5.6'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'


gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
#gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
#gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]


# less(CSS)対応（後述LESSを使う場合）
gem 'less-rails'
# JavaScript のエンジンである v8 を Ruby から使えるようにする
gem 'therubyracer'
# JavaScriptコードを実行するためのエンジン
gem 'execjs'

# Twitter社が提供しているCSSとJavaScriptのフレームワーク
gem 'twitter-bootstrap-rails'

# シンプルフォーム
gem 'simple_form'

# 日時を操作するためのライブラリ
gem 'momentjs-rails'

# DateTimePicker
gem 'datetimepicker-rails', github: 'zpaulovics/datetimepicker-rails', branch: 'master', submodules: true

#CoffeeScriptとSCSSをコンパイルしてくれます
#http://qiita.com/shizuma/items/1980bf885906c73238b6
gem 'sprockets', '~> 3.6.0'

#日付、時間などのValidationを支援してくれます。
#http://lorica.hatenablog.com/entry/2016/03/08/191425
gem 'validates_timeliness'

#gem 'jquery-turbolinks'

gem 'rename'

#gem 'devise'
# Use devise from a branch of koic/devise until devise 4.3.1 or higher.
gem 'devise'
gem 'devise-bootstrap-views'
gem 'devise-i18n'
gem 'devise-i18n-views'
gem "config"

#ページネーションを実現する
#http://ruby-rails.hatenadiary.com/entry/20141113/1415874683
gem 'kaminari'

#削除確認ダイアログをいい感じにする
#http://fiveteesixone.lackland.io/2015/02/06/rails-nice-delete-verification-modal/
gem 'data-confirm-modal'

#検索機能を実装するためのgem
gem "ransack"

#cron バッチ処理用
gem 'whenever', require: false

gem "font-awesome-rails"
gem 'unicorn'
