class Admin::AdminController < ApplicationController

	layout 'admin'
	before_filter :authenticate_admin_user!
	before_action :set_locale

	private 

	def set_locale
		I18n.locale = :en
	end

end