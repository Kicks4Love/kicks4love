class Admin::PostsController < ApplicationController

	def index
		@posts = Post.all.order(:created_at, :DESC)
	end

	def new
		@post = Post.new
		@image_list = Dir.glob("#{Rails.root}/app/assets/images/post/*").map{|path| path.split('/').last}
	end
	
end
