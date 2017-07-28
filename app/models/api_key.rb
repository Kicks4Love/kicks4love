class ApiKey < ApplicationRecord

  	belongs_to :admin_user
  	before_create :generate_access_token

  	private
  
  	def generate_access_token
    	begin
      	self.access_token = SecureRandom.hex
    	end while self.class.exists?(access_token: access_token)
  	end

end