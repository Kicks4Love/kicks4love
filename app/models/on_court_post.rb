class OnCourtPost < ApplicationRecord

	attr_accessor :post_link

	scope :latest, -> {order("created_at DESC")}

	self.per_page = 3

	mount_uploader :cover_image, OnCourtUploader
	mount_uploader :main_image, OnCourtUploader

end