class OnCourtPost < ApplicationRecord
  scope :latest, -> {order("created_at DESC")}
end
