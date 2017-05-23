class TrendPost < ApplicationRecord

	attr_accessor :post_type

	include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

	serialize :content_en, Array
	serialize :content_cn, Array
	serialize :main_images, JSON

	belongs_to :author, class_name: "AdminUser"

  scope :latest, -> {order(:created_at => :DESC)}
	scope :old, -> {where("created_at < ?", 3.month.ago)}

	mapping do
  	indexes :id, index: :not_analyzed
  	indexes :title_en
  	indexes :title_cn
  	indexes :content_cn
  	indexes :content_en
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
            fields: ["title_en^9", "title_cn^9", "content_cn", "content_en"],
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

end