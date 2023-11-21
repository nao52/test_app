class GoogleLoginApiController < ApplicationController
  skip_before_action :require_login
  before_action :google_login_api

  def callback
    auth = request.env['omniauth.auth']
    access_token = auth.credentials.token
    subscription_channels = Channel.subscription_channels(access_token)
    current_user.add_subscriptions(subscription_channels)
    render "static_pages/top"
    # redirect_to login_path, success: 'ログインしました'
  end
end
