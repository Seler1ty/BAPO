FactoryBot.define do
  factory :comment do
    article
    user
    body { 'Nice post!' }
  end
end
