FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    user

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      after(:build) do |question|
        question.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb')
      end
    end
  end
end
