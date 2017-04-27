class Admin::PostsController < Admin::AdminController

	skip_before_filter :verify_authenticity_token, :only => [:destroy]
	before_action :get_post, :only => [:edit, :destroy, :update, :show]

	def index
		@page_title = "Kicks4Love Admin | Posts"
		@posts = Post.posts
		@news = Post.news
	end

	def new
		@post = Post.new
		@page_title = "Kicks4Love Admin | New Post"
	end

	def create
		post = Post.new post_params

		if post.save
			redirect_to admin_posts_path, :notice => "New post successfully created"
		else
			redirect_to :back, :alert => "Error creating new post"
		end
	end

	def update
		if @post.update_attributes(post_params)
			flash[:notice] = "The post has been successfully updated"
		else
			flash[:alert] = "Error occurs while updating the post, please try again"
		end

		redirect_to admin_posts_path
	end

	def edit
		@page_title = "Kicks4Love Admin | Edit Post"
	end

	def destroy
		if @post.destroy
			flash[:notice] = "The post has been deleted successfully"
		else
			flash[:alert] = "Error occurs while deleting the post, please try again"
		end

		redirect_to admin_posts_path
	end

	# JSON API getting lastest posts
	def get_posts
		head :ok and return unless params[:type].present?

		case params[:type].downcase
		when "features"
			posts = FeaturePost.select(:id, :title).latest
		when "on_court"
			posts = OnCourtPost.select("id, title_en AS title").latest
		end

		render :json => posts.to_json, :layout => false
	end
		
	private

	def post_params
		params.require(:post).permit(:title, :content, :post_type, :image)
	end

	def get_post
		@post = Post.find_by_id(params[:id])
	end

end