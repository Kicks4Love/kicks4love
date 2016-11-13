class MainController < ApplicationController

	def index
		all_posts = Post.all.order(:created_at => :DESC)
		@news_posts = all_posts.where(:post_type => :NEWS)
		@regular_posts = all_posts.where(:post_type => :POST)
	end

end
