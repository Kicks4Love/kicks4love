class Admin::AdminUsersController < Admin::AdminController

	def index
		@root_user = AdminUser.root_user
		@admin_users = AdminUser.non_root_users
	end

	def show
	end

end