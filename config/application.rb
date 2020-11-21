require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Warehouse
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    
    # Stripe test keys for development and test environments, production keys in 
    # config/environments/production.rb.
    config.stripe.secret_key = Rails.application.credentials.stripe[:development][:secret_key]
    config.stripe.publishable_key = Rails.application.credentials.stripe[:development][:publishable_key]
  end
end
