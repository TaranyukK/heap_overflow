FactoryBot.define do
  factory :question do
    title { 'My Question Title' }
    body { 'My Question Body' }
    user

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      after(:build) do |question|
        question.files.attach(io: Rails.root.join('spec/rails_helper.rb').open, filename: 'rails_helper.rb')
      end
    end

    trait :with_link do
      after(:create) do |question|
        create(:link, linkable: question)
      end
    end

    trait :with_award do
      after(:create) do |question|
        create(:award, question: question)
      end
    end
  end
end
