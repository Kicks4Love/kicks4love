class Admin::AdminUsersController < Admin::AdminController

	before_action :get_admin_user, :only => [:show]

	def index
		@root_user = AdminUser.root_user
		@admin_users = AdminUser.non_root_users
	end

	def show
	end

	private

	def get_admin_user
		@admin_user = AdminUser.find_by_id(params[:id])
	end

end