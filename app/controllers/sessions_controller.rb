class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      token = encode_token({ user_id: user.id })
      render json: { token: token, user: user.as_json(only: [ :id, :username, :email ]) }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def register
    user = User.create!(register_params)
    token = encode_token({ user_id: user.id })
    render json: { token: token, user: user.as_json(only: [ :id, :username, :email ]) }, status: :created
  end

  private

  def register_params
    params.require(:user).permit(:username, :email, :password, :bio, :image)
  end
end
