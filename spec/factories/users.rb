FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@test.com" }
    password { '12345678' }
    password_confirmation { '12345678' }

    trait :with_award do
      after(:build) do |user|
        question = create(:question, :with_award)

        user.awards << question.award
      end
    end

    trait :admin do
      admin { true }
    end
  end
end
