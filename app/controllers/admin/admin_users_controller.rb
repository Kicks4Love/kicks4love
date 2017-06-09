class Admin::AdminUsersController < Admin::AdminController

	skip_before_filter :verify_authenticity_token, :only => [:destroy]
	before_action :get_admin_user, :only => [:show, :destroy]

	def index
		@page_title = "Admin Users | Kicks4Love Admin"
		@root_user = AdminUser.root_user
		@admin_users = AdminUser.non_root_users
	end

	def show
		user_name = AdminUser.find_by_id(params[:id]).username
		@page_title = "#{user_name} | Kicks4Love Admin"
	end

	def destroy
		if @admin_user.root_user?
			redirect_to :back, :alert => 'Root user cannot be deleted' and return
		end

		is_root_user = current_admin_user.root_user?
		sign_out @admin_user unless is_root_user

		if @admin_user.delete
			if is_root_user
				redirect_to admin_admin_users_path, :notice => "#{@admin_user.email} deleted successfully"
			else
				redirect_to new_admin_user_session_path, :notice => 'Account deleted successfully'
			end
			return
		end
			
		redirect_to :back, :alert => 'Unable to destroy the admin user: ' << @admin_user.errors[:base].to_s
	end

	private

	def get_admin_user
		@admin_user = AdminUser.find_by_id(params[:id])
	end

end