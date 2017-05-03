class CalendarPost < ApplicationRecord

	enum :release_type => [:SNEAKER, :CLOTH, :ACCESSORY, :OTHER]

	scope :latest, -> {order(:created_at => :DESC)}

	mount_uploader :cover_image, ImageUploader

end