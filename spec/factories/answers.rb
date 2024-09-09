FactoryBot.define do
  factory :answer do
    body { "My Body" }
    question

    trait :invalid do
      body { nil }
    end
  end
end
