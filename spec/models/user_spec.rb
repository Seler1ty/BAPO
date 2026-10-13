require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_uniqueness_of(:username) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to have_many(:articles).dependent(:destroy) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }
end
