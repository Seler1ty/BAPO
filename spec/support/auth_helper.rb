module AuthHelper
  def auth_headers(user)
    token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
    { 'Authorization' => "Bearer #{token}" }
  end

  def json_body
    JSON.parse(response.body, symbolize_names: true)
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :request
end
