class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :messages_count #未読のメッセージ件数取得

  before_action :affiliate_get #広告情報取得

  before_action :bank_check     #NISA口座が未登録は、NISA口座登録画面に強制遷移
  before_action :configure_permitted_parameters, if: :devise_controller?

  # 例外ハンドル
  if !Rails.env.development?
    rescue_from Exception,                        with: :render_500
    rescue_from ActiveRecord::RecordNotFound,     with: :render_404
    rescue_from ActionController::RoutingError,   with: :render_404
  end

  def raise_not_found!
    raise ActionController::RoutingError.new(params[:path])
  end

  def render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e

    if request.xhr?
      render json: { error: '404 error' }, status: 404
    else
      format = params[:format] == :json ? :json : :html
      #render template: 'errors/error_404', formats: format, status: 404, layout: 'application', content_type: 'text/html'
      render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
    end
  end

  def render_500(e = nil)
    logger.info "Rendering 500 with exception: #{e.message}" if e
    #Airbrake.notify(e) if e # Airbrake/Errbitを使う場合はこちら

    if request.xhr?
      render json: { error: '500 error' }, status: 500
    else
      format = params[:format] == :json ? :json : :html
      #render template: 'errors/error_500', formats: format, status: 500, layout: 'application', content_type: 'text/html'
      render file: Rails.root.join('public/500.html'), status: 500, layout: false, content_type: 'text/html'
    end
  end

  private

  #未読のメッセージ件数取得
  def messages_count
    if user_signed_in?
      #未読メッセージ件数取得
      @messages_no_read = Message.joins("LEFT JOIN message_reads on messages.id=message_reads.message_id").where("messages.user_id=? or messages.user_id is null",current_user.id.to_s)
                      .select("messages.*,message_reads.read_flg,message_reads.delete_flg")
                      .order("messages.created_at desc")
                      .where.not(id: MessageRead.where("message_reads.user_id=? and read_flg=?",current_user.id,true).select("message_id"))



    end
  end

  #NISA口座が未登録は、NISA口座登録画面に強制遷移
  def bank_check
    if user_signed_in? and (request.fullpath.to_s.include?(stock_holds_path) or request.fullpath.to_s.include?(dividends_path) or request.fullpath.to_s=="/")
      if User.joins(:banks).where("users.id = ?" ,current_user.id ).records.count==0
          flash[:notice] = "はじめに口座情報を登録してください"

        redirect_to "/banks/new"
      end
    end
  end

  #広告情報取得
  def affiliate_get
    @affiliate_finance = Affiliate.where("company=?","finance").all.order("RAND()").limit(1)

    @affiliate_pc = Affiliate.where("company=?","link_share_pc").all.order("RAND()").limit(1)

    @affiliate_sm = Affiliate.where("company in (?,?,?)","link_share_smart","","").all.order("RAND()").limit(1)
  end

  #サインインなしはログイン画面に遷移
  def sign_in_required
    redirect_to new_user_session_url unless user_signed_in?
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username,:mail_enabled])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username,:mail_enabled])
  end
end
