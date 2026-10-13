require 'rails_helper'

RSpec.describe Article, type: :model do
  subject { build(:article) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }
  it { is_expected.to have_many(:article_tags).dependent(:destroy) }
  it { is_expected.to have_many(:tags).through(:article_tags) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:body) }

  describe 'slug generation' do
    it 'generates slug from title on create' do
      article = create(:article, title: 'My Great Post!')
      expect(article.slug).to eq('my-great-post')
    end
  end

  describe 'scopes' do
    let!(:alice) { create(:user, username: 'alice') }
    let!(:bob)   { create(:user, username: 'bob') }
    let!(:first)  { create(:article, user: alice, title: 'A1', created_at: 2.days.ago) }
    let!(:second) { create(:article, user: bob, title: 'B1') }
    let!(:ruby_tag) { create(:tag, name: 'ruby') }

    before { first.tags << ruby_tag }

    it '.by_author filters by username' do
      expect(Article.by_author('alice')).to contain_exactly(first)
    end

    it '.by_tag filters by tag name' do
      expect(Article.by_tag('ruby')).to contain_exactly(first)
      expect(Article.by_tag('unknown')).to be_empty
    end

    it '.recent orders by created_at desc' do
      expect(Article.recent).to eq([second, first])
    end
  end
end
