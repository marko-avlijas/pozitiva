require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Pozitiva
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Zagreb'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :hr
    
    # config.action_mailer.smtp_settings = {
    #   :address              => "smtp.gmail.com",
    #   :port                 => 587,
    #   :domain               => "gmail.com",
    #   :user_name            => ENV['MAILER_USER'],
    #   :password             => ENV['MAILER_PASS'],
    #   :authentication       => :plain,
    #   :enable_starttls_auto => true
    # }
    
    # config.action_mailer.smtp_settings = {
    #   :address              => "in.mailjet.com",
    #   :port                 => 587,
    #   :user_name            => ENV['MAILER_USER'],
    #   :password             => ENV['MAILER_PASS'],
    #   :authentication       => :plain,
    #   :enable_starttls_auto => true
    # }

    config.action_mailer.smtp_settings = {
      :address              => "smtp.mandrillapp.com",
      :port                 => 587,
      :user_name            => ENV['MAILER_USER'],
      :password             => ENV['MAILER_PASS'],
      :authentication       => :plain,
      :enable_starttls_auto => true
    }
    
    config.action_mailer.default_url_options = {
      # :host => "pozitiva.herokuapp.com"
      host: ENV['SITE_HOST']
    }
  end
end
