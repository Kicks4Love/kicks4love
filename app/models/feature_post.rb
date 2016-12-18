class FeaturePost < ApplicationRecord

  	scope :latest, -> {order(:created_at => :DESC)}

	self.per_page = 3
	
end
