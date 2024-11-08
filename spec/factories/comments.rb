FactoryBot.define do
  factory :comment do
    user
    body { 'MyText' }

    trait :invalid do
      body { nil }
    end
  end
end
