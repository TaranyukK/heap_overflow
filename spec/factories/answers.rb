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

    trait :with_file do
      after(:build) do |answer|
        answer.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb')
      end
    end

    trait :with_link do
      after(:create) do |answer|
        create(:link, linkable: answer)
      end
    end
  end
end
