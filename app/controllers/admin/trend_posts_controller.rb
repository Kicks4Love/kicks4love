class Admin::TrendPostsController < Admin::AdminController

	skip_before_filter :verify_authenticity_token, :only => [:destroy]
	before_action :get_trend_post, :only => [:edit, :destroy, :update, :show]

	def index
		@page_title = "Kicks4Love Admin | Trend Posts"
		@trend_posts = TrendPost.all.order(:created_at => :DESC)
	end

	def new
		@trend_post = TrendPost.new
		@image_list = Dir.glob("#{Rails.root}/app/assets/images/trend_post/*").map{|path| path.split('/').last}
		@page_title = "Kicks4Love Admin | New Trend Post"
	end

	def create
		trend_post = TrendPost.new trend_post_params

		if trend_post.save
			redirect_to admin_trend_posts_path, :notice => "New trend post successfully created"
		else
			redirect_to :back, :error => "Error creating new trend post"
		end
	end

	def update
		if @trend_post.update_attributes(trend_post_params)
			flash[:notice] = "The trend post has been successfully updated"
		else
			flash[:error] = "Error occurs while updating the trend post, please try again"
		end

		redirect_to admin_trend_posts_path
	end

	def edit
		@image_list = Dir.glob("#{Rails.root}/app/assets/images/trend_post/*").map{|path| path.split('/').last}
		@page_title = "Kicks4Love Admin | Edit Trend Post"
	end

	def destroy
		if @trend_post.destroy
			flash[:notice] = "The feature_post has been deleted successfully"
		else
			flash[:error] = "Error occurs while deleting the featire post, please try again"
		end

		redirect_to admin_trend_posts_path
	end

	private

	def trend_post_params
		params.require(:trend_post).permit(:title, :content, :image)
	end

	def get_trend_post
		@trend_post = TrendPost.find_by_id(params[:id])
	end

end
