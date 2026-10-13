require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'POST /users (register)' do
    let(:valid_params) do
      { user: { username: 'newbie', email: 'newbie@example.com', password: 'password123' } }
    end

    it 'creates user and returns token' do
      expect { post '/users', params: valid_params }.to change(User, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json_body[:token]).to be_present
      expect(json_body[:user][:username]).to eq('newbie')
    end

    it 'returns 422 on invalid params' do
      post '/users', params: { user: { username: '', email: 'bad', password: 'x' } }
      expect(response).to have_http_status(422)
    end
  end

  describe 'POST /users/login' do
    let!(:user) { create(:user, email: 'login@example.com', password: 'secret123') }

    it 'returns token on valid credentials' do
      post '/users/login', params: { email: 'login@example.com', password: 'secret123' }
      expect(response).to have_http_status(:ok)
      expect(json_body[:token]).to be_present
    end

    it 'returns 401 on wrong password' do
      post '/users/login', params: { email: 'login@example.com', password: 'nope' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 for unknown email' do
      post '/users/login', params: { email: 'ghost@example.com', password: 'secret123' }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
