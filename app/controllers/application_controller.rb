class ApplicationController < ActionController::Base
  before_action :require_login
  add_flash_types :success, :danger

  def google_login_api
    @google_client_id = Settings.google_client_id
    @google_login_uri = Settings.google_login_uri
  end

  private

  def not_authenticated
    redirect_to root_path
  end
end
