class TrendPost < ApplicationRecord

    scope :latest, -> {order( :created_at => :DESC)}

    self.per_page = 3
    
	mount_uploader :main_image, FeatureUploader
	mount_uploader :cover_image, FeatureUploader
  end
