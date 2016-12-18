class Admin::RegistrationsController < Devise::RegistrationsController

	layout 'admin'
	prepend_before_filter :require_no_authentication, :only => []

end