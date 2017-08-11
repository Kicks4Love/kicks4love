class Admin::RegistrationsController < Devise::RegistrationsController

	layout 'admin'
	prepend_before_filter :require_no_authentication, :only => []
	skip_before_filter :verify_authenticity_token, :only => [:destroy]

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
			if params[:set_api_key]
				resource.api_key = ApiKey.create
			end
		end
	end

	def update
		super do |resource|
			if params[:set_api_key]
				if resource.api_key.present?
					resource.api_key.delete
				end
				resource.api_key = ApiKey.create
			end
		end
	end

	def sign_up_params
		params.require(:admin_user).permit(:username, :email, :password, :password_confirmation, :set_api_key)
	end

	def account_update_params
		params.require(:admin_user).permit(:username, :email, :password, :password_confirmation, :current_password, :set_api_key)
	end

	protected

	def after_sign_up_path_for(resource)
  		admin_admin_user_path(resource)
	end

	def after_update_path_for(resource)
      admin_admin_user_path(resource)
    end

end