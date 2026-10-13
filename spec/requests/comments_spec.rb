require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:author) { create(:user) }
  let(:article) { create(:article, user: author) }
  let(:commenter) { create(:user) }
  let!(:comment) { create(:comment, article: article, user: commenter) }

  describe 'GET /articles/:slug/comments' do
    it 'returns comments without auth' do
      get "/articles/#{article.slug}/comments"
      expect(response).to have_http_status(:ok)
      expect(json_body[:comments].size).to eq(1)
      expect(json_body[:comments].first[:author][:username]).to eq(commenter.username)
    end
  end

  describe 'POST /articles/:slug/comments' do
    it 'requires auth' do
      post "/articles/#{article.slug}/comments", params: { comment: { body: 'Hi' } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'creates comment for authenticated user' do
      expect {
        post "/articles/#{article.slug}/comments",
             params: { comment: { body: 'Great!' } },
             headers: auth_headers(commenter)
      }.to change(Comment, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'returns 422 on empty body' do
      post "/articles/#{article.slug}/comments",
           params: { comment: { body: '' } },
           headers: auth_headers(commenter)
      expect(response).to have_http_status(422)
    end
  end

  describe 'DELETE /articles/:slug/comments/:id' do
    it 'allows comment owner' do
      delete "/articles/#{article.slug}/comments/#{comment.id}",
             headers: auth_headers(commenter)
      expect(response).to have_http_status(:no_content)
    end

    it 'forbids non-owner' do
      delete "/articles/#{article.slug}/comments/#{comment.id}",
             headers: auth_headers(create(:user))
      expect(response).to have_http_status(:forbidden)
      expect(Comment.count).to eq(1)
    end
  end
end
