require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Nusucheck
  class Application < Rails::Application
    config.load_defaults 7.1

    config.autoload_lib(ignore: %w[assets tasks])

    config.time_zone = "Seoul"
    config.i18n.default_locale = :ko
    config.i18n.available_locales = [:ko, :en]

    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: "spec/factories"
      g.helper false
      g.assets false
    end
  end
end
