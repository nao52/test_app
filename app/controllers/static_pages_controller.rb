class StaticPagesController < ApplicationController
  skip_before_action :require_login
  before_action :google_client_id, only: :top
  
  def top
  end
end
