class ErrorsController < ApplicationController
  	def not_found
  		I18n.locale = session[:language] || I18n.default_locale
  		render(:status => 404)
  	end

  	def internal_server_error
  		I18n.locale = session[:language] || I18n.default_locale
  		render(:status => 500)
  	end
end