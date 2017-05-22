class OnCourtPost < ApplicationRecord

	attr_accessor :post_type

	serialize :content_en, Array
	serialize :content_cn, Array
	serialize :main_images, JSON

	belongs_to :author, class_name: "AdminUser"

	scope :latest, -> {order("created_at DESC")}
	scope :old, -> {where("created_at < ?", 3.month.ago)}
	scope :with_link, -> {where("content_en IS NOT NULL AND content_cn IS NOT NULL AND main_images IS NOT NULL")}

	self.per_page = 3

	mount_uploader :cover_image, ImageUploader
	mount_uploaders :main_images, ImageUploader

	def has_link
		return self.main_images.count > 0 && self.content_en.count > 0 && self.content_cn.count > 0
	end

end
