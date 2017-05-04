class TrendPost < ApplicationRecord

	attr_accessor :post_link

    scope :latest, -> {order( :created_at => :DESC)}

    self.per_page = 3

	mount_uploader :main_image, ImageUploader
	mount_uploader :cover_image, ImageUploader
	
  end
