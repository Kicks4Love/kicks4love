class FeaturePost < ApplicationRecord
  scope :latest, -> {order("created_at DESC")}
end
