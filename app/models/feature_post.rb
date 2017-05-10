class FeaturePost < ApplicationRecord

	attr_accessor :post_type

  	scope :latest, -> {order(:created_at => :DESC)}
	scope :old, -> {where("created_at < ?", 3.month.ago)}

	self.per_page = 3

	mount_uploader :main_image_1, ImageUploader
	mount_uploader :main_image_2, ImageUploader
	mount_uploader :main_image_3, ImageUploader
	mount_uploader :cover_image, ImageUploader

end
