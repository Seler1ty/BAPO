require 'rails_helper'

RSpec.describe 'Tags', type: :request do
  it 'returns only tags attached to articles' do
    article = create(:article)
    used = create(:tag, name: 'used')
    create(:tag, name: 'unused')
    article.tags << used

    get '/tags'
    expect(response).to have_http_status(:ok)
    expect(json_body[:tags]).to eq(['used'])
  end
end
