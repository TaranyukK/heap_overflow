require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'cancan/matchers'

Dir[Rails.root.join('spec','support', '**', '*.rb')].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
  config.include FeatureHelpers, type: :feature
  config.include VoteHelpers, type: :model
  config.include ApiHelpers, type: :request

  Capybara.javascript_driver = :selenium_chrome_headless

  config.fixture_path = Rails.root.join('spec/fixtures')

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!


  config.before(:suite) do
    FileUtils.rm_rf(Rails.root.join('public', 'packs-test'))
    system('RAILS_ENV=test bundle exec rails webpacker:compile')
  end

  config.after(:all) do
    FileUtils.rm_rf(Rails.root.join('tmp', 'storage'))
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
