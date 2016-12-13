class Post < ApplicationRecord

	enum :post_type => [:POST, :NEWS]

	scope :latest, -> {order("created_at DESC")}

	self.per_page = 3

end
