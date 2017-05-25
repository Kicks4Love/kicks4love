require 'elasticsearch/model'

class TrendPost < ApplicationRecord

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

	attr_accessor :post_type

	serialize :content_en, Array
	serialize :content_cn, Array
	serialize :main_images, JSON

  belongs_to :author, class_name: "AdminUser"

  scope :latest, -> {order(:created_at => :DESC)}
	scope :old, -> {where("created_at < ?", 3.month.ago)}

  self.per_page = 3

  mount_uploader :cover_image, ImageUploader
  mount_uploaders :main_images, ImageUploader

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :title_en
      indexes :title_cn
      indexes :content_cn
      indexes :content_en
    end
  end

  def self.as_indexed_json(options={})
    self.as_json({only: [:title_en, :title_cn, :content_en, :content_cn]})
  end

end

TrendPost.import