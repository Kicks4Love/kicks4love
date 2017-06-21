class Admin::PostsController < Admin::AdminController

	skip_before_filter :verify_authenticity_token, :only => [:destroy]
	before_action :get_post, :only => [:edit, :destroy, :update, :show]

	def index
		@page_title = "Posts | Kicks4Love Admin"
		@posts = Post.posts
		@news = Post.news
	end

	def new
		@post = Post.new
		@page_title = "New Post | Kicks4Love Admin"
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
		@page_title = "Edit Post | Kicks4Love Admin"
	end

	def destroy
		id = @post.id
		if @post.destroy
			Admin::AdminHelper.remove_uploads_file('post', id)
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
			posts = FeaturePost.select(:id, :title_en).latest
		when "calendar"
			posts = CalendarPost.select(:id, :title_en).latest
		when "trend"
			posts = TrendPost.select(:id, :title_en).latest
		when "on_court"
			posts = OnCourtPost.select(:id, :title_en).latest
		when "street_snap"
			posts = StreetSnapPost.select(:id, :title_en).latest
		when "rumors"
			posts = RumorPost.select(:id, :title_en).latest
		end

		render :json => posts.to_json, :layout => false
	end

	def send_newsletter
		begin
			CustomerServiceMailer.send_newsletter(Subscriber.all)
			flash[:notice] = "Newsletter sent"
		rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError  => e
			flash[:alert] = "Somthing wrong happened: " + e.message
		end
		redirect_to :back
	end

	private

	def post_params
		params.require(:post).permit(:title_en, :title_cn, :post_type, :pointer_type, :pointer_id, :image)
	end

	def get_post
		@post = Post.find_by_id(params[:id])
	end

end