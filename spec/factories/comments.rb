FactoryBot.define do
  factory :comment do
    user
    body { 'My Comment Body' }

    trait :invalid do
      body { nil }
    end
  end
end
