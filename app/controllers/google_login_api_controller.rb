class GoogleLoginApiController < ApplicationController
  before_action :google_login_api

  def callback
    auth = request.env['omniauth.auth']
    access_token = auth.credentials.token
    subscription_channels = Channel.subscription_channels(access_token)
    current_user.add_subscriptions(subscription_channels)
    redirect_to channels_user_path(current_user), success: '登録チャンネル/高評価動画を同期しました'
  end
end
