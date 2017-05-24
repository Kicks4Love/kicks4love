class CalendarPost < ApplicationRecord

	enum :release_type => [:SNEAKER, :CLOTH, :ACCESSORY, :OTHER]

	scope :latest, -> {order(:created_at => :DESC)}

	scope :old, -> {where("release_date < ?", 1.month.ago)}

	mount_uploader :cover_image, ImageUploader

end