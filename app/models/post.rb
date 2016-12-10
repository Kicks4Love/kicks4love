class Post < ApplicationRecord

	enum :post_type => [:POST, :NEWS]

	self.per_page = 3
	
end
