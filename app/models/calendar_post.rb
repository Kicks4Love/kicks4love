require 'elasticsearch/model'

class CalendarPost < ApplicationRecord

	include Elasticsearch::Model
    #include Elasticsearch::Model::Callbacks

	enum :release_type => [:SNEAKER, :CLOTH, :ACCESSORY, :OTHER]

	scope :latest, -> {order(:created_at => :DESC)}
    scope :order_by_release_date, ->{order(:release_date => :DESC)}
	scope :old, -> {where("release_date < ?", 1.month.ago)}

	mount_uploader :cover_image, ImageUploader

	settings index: { number_of_shards: 1 } do
        mappings dynamic: 'false' do
            indexes :title_en
            indexes :title_cn
        end
    end

    def self.as_indexed_json(options={})
        self.as_json({only: [:title_en, :title_cn]})
    end

end

CalendarPost.import force: true