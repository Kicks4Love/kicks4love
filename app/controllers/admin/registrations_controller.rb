class Admin::RegistrationsController < Devise::RegistrationsController

	layout 'admin'
	prepend_before_filter :require_no_authentication, :only => []

	def new
		super do |resource|
	    	unless admin_user_signed_in?
	    		redirect_to new_admin_user_session_path, :alert => 'You need to login before continue' and return
	    	end
	    	unless current_admin_user.root_user?
	    		redirect_to admin_root_path, :alert => 'Only root user can register a new admin user' and return
	    	end
	    end
	end

	def create
		super do |resource|
		end
	end

end