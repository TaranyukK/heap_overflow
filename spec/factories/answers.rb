FactoryBot.define do
  factory :answer do
    body { "My Body" }
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :best do
      best { true }
    end
  end
end
