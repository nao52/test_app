class GoogleLoginApiController < ApplicationController
  require 'googleauth/id_tokens/verifier'

  protect_from_forgery except: :callback

  skip_before_action :require_login
  before_action :verify_g_csrf_token
  before_action :google_client_id

  def callback
    Google::Auth::IDTokens.verify_oidc(params[:credential], aud: @google_client_id)
    redirect_to login_path, success: 'ログインしました'
  end

  private

  def verify_g_csrf_token
    if cookies["g_csrf_token"].blank? || params[:g_csrf_token].blank? || cookies["g_csrf_token"] != params[:g_csrf_token]
      redirect_to root_path, danger: '不正なアクセスです'
    end
  end
end
