class Admin::SessionsController < Devise::SessionsController

  layout 'admin'
  skip_before_filter :verify_authenticity_token, :only => [:destroy]
  
end