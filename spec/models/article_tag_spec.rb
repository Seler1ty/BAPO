require 'rails_helper'

RSpec.describe ArticleTag, type: :model do
  subject { build(:article_tag) }

  it { is_expected.to belong_to(:article) }
  it { is_expected.to belong_to(:tag) }

  it 'prevents duplicate article-tag pairs' do
    article = create(:article)
    tag = create(:tag)
    create(:article_tag, article: article, tag: tag)

    duplicate = build(:article_tag, article: article, tag: tag)
    expect(duplicate).not_to be_valid
  end
end
