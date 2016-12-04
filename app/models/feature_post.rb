class FeaturePost < ApplicationRecord

	self.per_page = 3
  scope :latest, -> {order("created_at DESC")}
	
end
