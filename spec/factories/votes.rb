FactoryBot.define do
  factory :vote do
    user
    value { 1 }

    trait :positive do
      value { -1 }
    end
  end
end
