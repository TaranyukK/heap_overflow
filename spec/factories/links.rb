FactoryBot.define do
  factory :link do
    sequence(:name) { |n| "Link Name #{n}" }
    sequence(:url) { |n| "https://www.test#{n}.com" }
  end
end
