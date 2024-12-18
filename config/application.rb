require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module HeapOverflow
  class Application < Rails::Application
    config.load_defaults 6.1

    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.test_framework :rspec,
                       view_specs:    false,
                       helper_specs:  false,
                       routing_specs: false,
                       request_specs: false
    end

    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }
  end
end
