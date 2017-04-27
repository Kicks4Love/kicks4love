class Post < ApplicationRecord

	enum :post_type => [:POST, :NEWS]
	enum :pointer_type => [:FEATURES, :ON_COURT]

	scope :latest, -> {order(:created_at => :DESC)}
	scope :posts, -> {where(:post_type => :POST)}
	scope :news, -> {where(:post_type => :NEWS)}

	mount_uploader :image, PostUploader

	def self.get_posts
		feature_posts = FeaturePost.select(:id, :title, :content, :image, :created_at)
		on_court_posts = OnCourtPost.select("id, title_en AS title, content_en AS content, main_image, created_at")
		
		return (feature_posts + on_court_posts).sort_by(&:created_at).reverse
	end

end