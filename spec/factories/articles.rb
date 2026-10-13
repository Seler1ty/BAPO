FactoryBot.define do
  factory :article do
    user
    sequence(:title) { |n| "Article #{n}" }
    description { 'Short description' }
    body { 'Full body text' }
  end
end
