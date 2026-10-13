require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:user) { create(:user, username: 'alice', bio: 'Old bio') }

  describe 'GET /profiles/:username' do
    it 'returns profile' do
      get '/profiles/alice'
      expect(response).to have_http_status(:ok)
      expect(json_body[:user][:username]).to eq('alice')
    end

    it 'returns 404 for unknown username' do
      get '/profiles/ghost'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PUT /user' do
    it 'requires auth' do
      put '/user', params: { user: { bio: 'New' } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'updates own profile' do
      put '/user', params: { user: { bio: 'New bio' } }, headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
      expect(user.reload.bio).to eq('New bio')
    end
  end
end
