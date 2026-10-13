require 'rails_helper'

RSpec.describe Tag, type: :model do
  subject { build(:tag) }

  it { is_expected.to have_many(:article_tags).dependent(:destroy) }
  it { is_expected.to have_many(:articles).through(:article_tags) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end
