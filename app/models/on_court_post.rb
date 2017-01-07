class OnCourtPost < ApplicationRecord

	scope :latest, -> {order("created_at DESC")}

	self.per_page = 6

	mount_uploader :cover_image, OnCourtUploader
	mount_uploader :main_image, OnCourtUploader

end
