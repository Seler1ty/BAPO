module Authenticatable
  extend ActiveSupport::Concern

  SECRET_KEY = Rails.application.secret_key_base

  def encode_token(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def decode_token
    auth_header = request.headers["Authorization"]
    return nil unless auth_header

    token = auth_header.split(" ").last
    JWT.decode(token, SECRET_KEY, true, { algorithm: "HS256" })[0]
  rescue JWT::DecodeError
    nil
  end

  def current_user
    return @current_user if @current_user

    payload = decode_token
    return nil unless payload

    @current_user = User.find_by(id: payload["user_id"])
  end

  def authenticate_user!
    render json: { error: "Not authorized" }, status: :unauthorized unless current_user
  end
end
