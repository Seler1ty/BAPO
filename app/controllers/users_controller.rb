class UsersController < ApplicationController
  before_action :authenticate_user!, only: [ :update ]

  def show
    user = User.find_by!(username: params[:username])
    render json: { user: user.as_json(only: [ :id, :username, :email, :bio, :image ]) }
  end

  def update
    current_user.update!(user_params)
    render json: { user: current_user.as_json(only: [ :id, :username, :email, :bio, :image ]) }
  end

  private

  def user_params
    params.require(:user).permit(:username, :bio, :image, :email, :password)
  end
end
