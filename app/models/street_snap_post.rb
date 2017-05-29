class StreetSnapPost < ApplicationRecord
  attr_accessor :post_type

	serialize :content_en, Array
	serialize :content_cn, Array
	serialize :main_images, JSON
  serialize :post_composition, JSON
	belongs_to :author, class_name: "AdminUser"

	scope :latest, -> {order("created_at DESC")}
	scope :old, -> {where("created_at < ?", 3.month.ago)}
  self.per_page = 3

  mount_uploader :cover_image, ImageUploader
  mount_uploaders :main_images, ImageUploader
end
