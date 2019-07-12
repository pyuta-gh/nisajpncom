Rails.application.routes.draw do
  get 'rules/index'

  resources :calenders
  resources :affiliates
  resources :dividends
  resources :message_reads
  resources :messages
  resources :system_infos
  resources :topics
  root :to => 'welcome#index'
  resources :stock_monitors
  resources :stock_infos
  resources :banks
  resources :stock_holds
  devise_for :users
  get 'welcome/index'
  get 'stock_holds/list/:p_list' , to: 'stock_holds#index'
  get '/stock_holds/:id/edit/:p_list' , to: 'stock_holds#edit'
  get '/stock_holds/new/:p_list' , to: 'stock_holds#new'
  get '/stock_holds/:id/:p_list' , to: 'stock_holds#show'
  patch '/stock_holds/:id/:p_list', to: 'stock_holds#update'

  get 'stock_infos/search/:p_list' , to: 'stock_infos#search'

  post 'stock_infos/search2' , to: 'stock_infos#search2'
  #post 'stock_infos/index' , to: 'stock_infos#index'

  get  'stock_infos/search2/:p_list' , to: 'stock_infos#search2'
  get 'stock_infos/hold/:p_list' , to: 'stock_infos#hold'
  get 'stock_monitors/new/:p_list' , to: 'stock_monitors#new'
  get 'banks/hold/:p_list' , to: 'banks#hold'

  #保有銘柄一覧から配当金登録
  get '/dividends/new/jpn_stock/:p_bank_id/:p_stock_type/:p_stock_code' , to: 'dividends#new'
  get '/dividends/new/jpn_other_stock/:p_bank_id/:p_stock_type/:p_stock_name' , to: 'dividends#new'
  get '/dividends/new/stock_code/:p_stock_code' , to: 'dividends#new'


  #お問い合わせ
  get 'inquiry' => 'inquiry#index'              # 入力画面
  post 'inquiry/confirm' => 'inquiry#confirm'   # 確認画面
  post 'inquiry/thanks' => 'inquiry#thanks'     # 送信完了画面

  #ルーティングエラーは、アプリケーションコントローラーのエラー処理を実行
  get  '*unmatched_route', to: 'application#raise_not_found!', format: false

  #get '/stock_infos', to: 'stock_infos#index'
  #get '/stock_infos/:id', to: 'stock_infos#show'
end
