FactoryBot.define do
  factory :authorization do
    provider { 'My Authorization Provider' }
    uid { '123456' }
    user
  end
end
