FactoryBot.define do
  factory :award do
    title { 'MyString' }
    question
    image { Rack::Test::UploadedFile.new("spec/fixtures/1x1.png", "image/png") }
  end
end
