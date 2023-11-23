class VideosController < ApplicationController
  skip_before_action :require_login

  def index
    @videos = Video.all
  end
end
