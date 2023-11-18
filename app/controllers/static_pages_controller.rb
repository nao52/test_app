class StaticPagesController < ApplicationController
  skip_before_action :require_login
  before_action :google_login_api
  
  def top
  end
end
