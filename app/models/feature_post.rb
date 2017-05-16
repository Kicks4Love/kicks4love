class FeaturePost < ApplicationRecord

	attr_accessor :post_type

	serialize :content_en, Array
	serialize :content_cn, Array

  	scope :latest, -> {order(:created_at => :DESC)}
	scope :old, -> {where("created_at < ?", 3.month.ago)}

	self.per_page = 3

	mount_uploaders :main_images, ImageUploader
	mount_uploader :cover_image, ImageUploader

	serialize :content_en, Array
	serialize :content_cn, Array

end
