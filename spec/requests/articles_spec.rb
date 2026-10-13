require 'rails_helper'

RSpec.describe 'Articles', type: :request do
  let(:author) { create(:user) }
  let!(:article) { create(:article, user: author, title: 'Hello World') }

  describe 'GET /articles' do
    it 'returns articles list' do
      get '/articles'
      expect(response).to have_http_status(:ok)
      expect(json_body[:articles].size).to eq(1)
      expect(json_body[:articles].first[:slug]).to eq('hello-world')
    end

    it 'filters by author' do
      create(:article, user: create(:user))
      get '/articles', params: { author: author.username }
      expect(json_body[:articles].size).to eq(1)
    end

    it 'filters by tag' do
      article.tags << create(:tag, name: 'ruby')
      get '/articles', params: { tag: 'ruby' }
      expect(json_body[:articles].size).to eq(1)

      get '/articles', params: { tag: 'unknown' }
      expect(json_body[:articles]).to be_empty
    end
  end

  describe 'GET /articles/:slug' do
    it 'returns article' do
      get "/articles/#{article.slug}"
      expect(response).to have_http_status(:ok)
      expect(json_body[:article][:title]).to eq('Hello World')
    end

    it 'returns 404 for unknown slug' do
      get '/articles/nope'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /articles' do
    let(:payload) do
      { article: { title: 'New', description: 'Desc', body: 'Body' }, tags: %w[ruby ddd] }
    end

    it 'requires authentication' do
      post '/articles', params: payload
      expect(response).to have_http_status(:unauthorized)
    end

    it 'creates article with tags' do
      expect {
        post '/articles', params: payload, headers: auth_headers(author)
      }.to change(Article, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json_body[:article][:tags]).to match_array(%w[ruby ddd])
      expect(json_body[:article][:author][:username]).to eq(author.username)
    end
  end

  describe 'PATCH /articles/:slug' do
    it 'allows owner to update' do
      patch "/articles/#{article.slug}",
            params: { article: { title: 'Updated' } },
            headers: auth_headers(author)
      expect(response).to have_http_status(:ok)
      expect(article.reload.title).to eq('Updated')
    end

    it 'forbids non-owner' do
      patch "/articles/#{article.slug}",
            params: { article: { title: 'Hacked' } },
            headers: auth_headers(create(:user))
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE /articles/:slug' do
    it 'allows owner to delete' do
      expect {
        delete "/articles/#{article.slug}", headers: auth_headers(author)
      }.to change(Article, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'forbids non-owner' do
      delete "/articles/#{article.slug}", headers: auth_headers(create(:user))
      expect(response).to have_http_status(:forbidden)
    end
  end
end
