class Admin::FeaturePostsController < Admin::AdminController

	def index
		@page_title = "Kicks4Love Admin | Feature Posts"
		@feature_posts = FeaturePost.all.order(:created_at => :DESC)
	end

	def new
		@feature_post = FeaturePost.new
		@image_list = Dir.glob("#{Rails.root}/app/assets/images/feautre_post/*").map{|path| path.split('/').last}
		@page_title = "Kicks4Love Admin | New Feature Post"
	end

end
