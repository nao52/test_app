class ChannelsController < ApplicationController
  skip_before_action :require_login

  def index
    @channels = Channel.all
  end
end
