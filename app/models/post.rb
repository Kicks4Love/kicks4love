
require 'elasticsearch/model'

class Post < ApplicationRecord
	include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

	enum :post_type => [:POST, :NEWS]
	enum :pointer_type => [:FEATURES, :ON_COURT, :TREND, :CALENDAR]
	mount_uploader :image, ImageUploader

	scope :latest, -> {order(:created_at => :DESC)}
	scope :posts, -> {where(:post_type => :POST)}
	scope :news, -> {where(:post_type => :NEWS)}

	mapping do
    	indexes :id, index: :not_analyzed
    	indexes :title_en
    	indexes :title_cn
    	indexes :image
    end	

	def as_indexed_json(options={}) 
    	self.as_json(only: [:id, :title_cn, :title_en]) 
  	end 

	def self.get_posts(chinese)
		if chinese
			feature_posts = FeaturePost.select("id, title_cn AS title, content_cn AS content, cover_image, created_at")
			trend_posts = TrendPost.select("id, title_cn AS title, content_cn AS content, cover_image, created_at")
			on_court_posts = OnCourtPost.select("id, title_cn AS title, content_cn AS content, cover_image, created_at").with_link
		else
			feature_posts = FeaturePost.select("id, title_en AS title, content_en AS content, cover_image, created_at")
			trend_posts = TrendPost.select("id, title_en AS title, content_en AS content, cover_image, created_at")
			on_court_posts = OnCourtPost.select("id, title_en AS title, content_en AS content, cover_image, created_at").with_link
		end
		
		return (feature_posts + trend_posts + on_court_posts).sort_by(&:created_at).reverse.each {|post| 
			post.content = ApplicationController.helpers.serialized_array_string_to_array(post.content)
		}
	end
end
Post.import


