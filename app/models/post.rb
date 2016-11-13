class Post < ApplicationRecord

	enum :post_type => [:POST, :NEWS]
	
end
