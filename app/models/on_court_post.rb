class OnCourtPost < ApplicationRecord
  self.per_page = 6
  scope :latest, -> {order("created_at DESC")}
end
