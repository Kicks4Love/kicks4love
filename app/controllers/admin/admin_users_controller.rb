class Admin::AdminUsersController < Admin::AdminController

	before_action :get_admin_user, :only => [:show, :destroy]

	def index
		@root_user = AdminUser.root_user
		@admin_users = AdminUser.non_root_users
	end

	def show
	end

	def destroy
		if @admin_user.root_user?
			redirect_to :back, :alert => 'Root user cannot be deleted'
		end

		redirect_to new_admin_user_session_path, :notice => 'Your account deleted successfully'
	end

	private

	def get_admin_user
		@admin_user = AdminUser.find_by_id(params[:id])
	end

end