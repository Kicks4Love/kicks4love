require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Kicks4love
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.exceptions_app = self.routes
    config.social_media = {
    	:facebook => 'https://www.facebook.com/kicks4love',
    	:weibo => 'https://weibo.com/u/5704994024',
    	:instagram => 'https://www.instagram.com/kicks4love'
    }
    config.email_list = {
        :leon => 'leonma333@kicks4love.com',
        :daniel => 'danielzhou@kicks4love.com',
        :jackie => 'jackiesun@kicks4love.com',
        :robin => 'robinlu@kicks4love.com',
        :error_notification => 'error@kicks4love.com',
        :customer_service => 'customerservice@kicks4love.com'
    }

  end
end