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

    config.host = 'https://kicks4love.com'
    config.exceptions_app = self.routes

    config.social_media = {
    	:facebook => 'https://www.facebook.com/kicks4love',
        :facebook_app_id => '1915795425355109',
    	:weibo => 'https://weibo.com/u/5704994024',
        :weibo_u_id => '5704994024',
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
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '/api/v0', :headers => :any, :methods => [:get, :post]
      end
    end
    
  end
end
