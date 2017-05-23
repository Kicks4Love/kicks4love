require 'elasticsearch/model'

class OnCourtPost < ApplicationRecord

    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

	attr_accessor :post_type

	serialize :content_en, Array
	serialize :content_cn, Array
	serialize :main_images, JSON

	belongs_to :author, class_name: "AdminUser"

	scope :latest, -> {order("created_at DESC")}
	scope :old, -> {where("created_at < ?", 3.month.ago)}
	scope :with_link, -> {where("content_en IS NOT NULL AND content_cn IS NOT NULL AND main_images IS NOT NULL")}

	mapping do
    	indexes :id, index: :not_analyzed
    	indexes :title_en
    	indexes :title_cn
    	indexes :content_cn
    	indexes :content_en
    	indexes :player_name_en
    	indexes :player_name_cn
    	indexes :cover_image, index: :no
    	indexes :main_images, index: :no
    	indexes :updated_at, index: :no
    	indexes :created_at, index: :no
    end		

    def self.custom_search(query)
        __elasticsearch__.search(
            {
            query: {
                multi_match: {
                    query: query,
                    type:  "best_fields",
                    fields: ["title_en^2", "title_cn^2", "player_name_en^1", "player_name_cn^1", "content_cn", "content_en"],
                    operator: "or",
                    zero_terms_query: "all"
                    }
                }
            }
        )
    end 

	self.per_page = 3

	mount_uploader :cover_image, ImageUploader
	mount_uploaders :main_images, ImageUploader

	def has_link
		return self.main_images.count > 0 && self.content_en.count > 0 && self.content_cn.count > 0
	end

end
