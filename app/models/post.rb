
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
    	indexes :updated_at, index: :no
    	indexes :created_at, index: :no
    	indexes :post_type, index: :no
    	indexes :pointer_type, index: :no
    	indexes :pointer_id, index: :no
    	indexes :image, index: :no
    end	


	def self.replace_key(old_key, new_key)
     self[new_key] = self[old_key]
     self.delete(old_key)
    end

    def self.custom_search(query)
  		__elasticsearch__.search(
    	{
      	query: {
       		 multi_match: {
          		query: query,
          		type:  "best_fields",
          		fields: ["title_en", "title_cn"],
          		operator: "or",
          		zero_terms_query: "all"
        		}
      		}
    	}
  	)
	end


	#class << self
	#   def custom_query(query)
	#    	__elasticsearch__.search(query: multi_match_query(query))
	#    end

	#    def multi_match_query(query)
	#    	{
	 ##  			query: 			query,
	 #
	 #   			type:       	"best_fields",
	 #     			field:     		["title_en", "title_en" ],
	 #     			tie_breaker: 	0.3
	 #   		}
	 #   	}
	 #   end
	#end



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


