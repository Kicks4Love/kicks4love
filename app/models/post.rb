class Post < ApplicationRecord

	enum :post_type => [:POST, :NEWS]
	enum :pointer_type => [:FEATURES, :ON_COURT, :TREND, :CALENDAR]

	scope :latest, -> {order(:created_at => :DESC)}
	scope :posts, -> {where(:post_type => :POST)}
	scope :news, -> {where(:post_type => :NEWS)}

	mount_uploader :image, ImageUploader

	def self.get_posts(chinese)
		if chinese
			feature_posts = FeaturePost.select("id, title_cn AS title, content_cn AS content, cover_image, created_at")
			trend_posts = TrendPost.select("id, title_cn AS title, content_cn AS content, cover_image, created_at")
			on_court_posts = OnCourtPost.select("id, title_cn AS title, content_cn AS content, cover_image, created_at").with_link
			rumor_posts = RumorPost.select("id, title_cn AS title, content_cn AS content, cover_image, created_at")
		else
			feature_posts = FeaturePost.select("id, title_en AS title, content_en AS content, cover_image, created_at")
			trend_posts = TrendPost.select("id, title_en AS title, content_en AS content, cover_image, created_at")
			on_court_posts = OnCourtPost.select("id, title_en AS title, content_en AS content, cover_image, created_at").with_link
			rumor_posts = RumorPost.select("id, title_en AS title, content_en AS content, cover_image, created_at")
		end

		return (feature_posts + trend_posts + on_court_posts + rumor_posts).sort_by(&:created_at).reverse.each {|post| post.content = post.content.blank? ? '' : YAML.load(post.content)}
	end

end
