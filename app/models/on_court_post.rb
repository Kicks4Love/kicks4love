require 'elasticsearch/model'

class OnCourtPost < ApplicationRecord

    include Elasticsearch::Model
    #include Elasticsearch::Model::Callbacks

	attr_accessor :post_type

	serialize :content_en, Array
	serialize :content_cn, Array
	serialize :main_images, JSON

	belongs_to :author, class_name: "AdminUser"

	scope :latest, -> {order("created_at DESC")}
	scope :old, -> {where("created_at < ?", 3.month.ago)}
	scope :with_link, -> {where("content_en IS NOT NULL AND content_cn IS NOT NULL AND main_images IS NOT NULL")}

    self.per_page = 3

    mount_uploader :cover_image, ImageUploader
    mount_uploaders :main_images, ImageUploader

    settings index: { number_of_shards: 1 } do
        mappings dynamic: 'false' do
            indexes :title_en
            indexes :title_cn
            indexes :content_en
            indexes :content_cn
            indexes :player_name_en
            indexes :player_name_cn
        end
    end

    def self.as_indexed_json(options={})
        self.as_json({only: [:title_en, :title_cn, :content_en, :content_cn]})
    end

	def has_link
		return self.main_images.count > 0 && self.content_en.count > 0 && self.content_cn.count > 0
	end

end

OnCourtPost.import force: true