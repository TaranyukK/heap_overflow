FactoryBot.define do
  factory :answer do
    body { "My Body" }
    question
    user

    trait :invalid do
      body { nil }
    end
  end
end
