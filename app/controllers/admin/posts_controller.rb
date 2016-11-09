class Admin::PostsController < Admin::AdminController

	def index
		@posts = Post.all.order(:created_at, :DESC)
		@page_title = "Kicks4Love Admin | Posts"
	end

	def new
		@post = Post.new
		@image_list = Dir.glob("#{Rails.root}/app/assets/images/post/*").map{|path| path.split('/').last}
		@page_title = "Kicks4Love Admin | New Post"
	end

	def create
		post = Post.new post_params

		if post.save
			redirect_to admin_posts_path, :notice => "New post successfully created"
		else
			redirect_to :back, :error => "Error creating new post"
		end
	end

	private 

	def post_params
		params.require(:post).permit(:title, :content, :image)
	end
	
end
