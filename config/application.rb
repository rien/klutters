require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Klutters
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.autoload_paths << "#{root}/app/services"

    config.tilisy_jwt_iss = 'enablebanking.com'
    config.tilisy_api_url = 'https://api.tilisy.com'
    config.tilisy_jwt_lifetime = 30.seconds

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.assets.paths << Rails.root.join("node_modules/remixicon/fonts")
  end
end
