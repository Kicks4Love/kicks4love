class TrendPost < ApplicationRecord

    scope :latest, -> {order("created_at DESC")}

    self.per_page =6
  end
