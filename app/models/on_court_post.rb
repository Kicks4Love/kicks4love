class OnCourtPost < ApplicationRecord

	attr_accessor :post_type

	scope :latest, -> {order("created_at DESC")}

	self.per_page = 3

	mount_uploader :cover_image, ImageUploader
	mount_uploader :main_image, ImageUploader

end