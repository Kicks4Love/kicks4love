class Admin::PostsController < Admin::AdminController

	skip_before_filter :verify_authenticity_token, :only => [:destroy]
	before_action :get_post, :only => [:edit, :destroy, :update, :show]

	def index
		@posts = Post.all.order(:created_at => :DESC)
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

	def update
		if @post.update_attributes(post_params)
			flash[:notice] = "The post has been successfully updated"
		else
			flash[:error] = "Error occurs while updating the post, please try again"
		end

		redirect_to admin_posts_path
	end

	def edit
		@image_list = Dir.glob("#{Rails.root}/app/assets/images/post/*").map{|path| path.split('/').last}
		@page_title = "Kicks4Love Admin | New Post"
	end

	def destroy
		if @post.destroy
			flash[:notice] = "The post has been deleted successfully"
		else
			flash[:error] = "Error occurs while deleting the post, please try again"
		end

		redirect_to admin_posts_path
	end

	private 

	def post_params
		params.require(:post).permit(:title, :content, :image)
	end

	def get_post
		@post = Post.find_by_id(params[:id])
	end
	
end
