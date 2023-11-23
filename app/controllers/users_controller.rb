class UsersController < ApplicationController
  skip_before_action :require_login
  before_action :set_user, only: %i[channels videos]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, success: "ユーザー登録を行いました"
    else
      render :new
    end
  end

  def channels
    @channels = @user.channels
  end

  def videos
    @videos = @user.videos
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
