class Admin::TrendPostsController < Admin::AdminController
	# expired_time = 7890000
	skip_before_filter :verify_authenticity_token, :only => [:destroy]
	before_action :get_trend_post, :only => [:edit, :destroy, :update, :show]

	def index
		@page_title = "Kicks4Love Admin | Trend Posts"
		@trend_posts = TrendPost.latest
		@expired_posts_count = 0;
		@trend_posts.each do |post|
			if 3.month.ago.to_i > post.created_at.to_i # more then 3 months old posts are marked 'expired'
				@expired_posts_count+=1
			end
		end
		if params[:filter].present?
			session[:trend_post_per_page] = params[:filter][:per_page].to_i
		end
		@per_page = session[:trend_post_per_page] || 10
		@trend_posts = @trend_posts.paginate(:page => params[:page] || 1, :per_page => session[:trend_post_per_page] || 10)
	end

	def new
		@trend_post = TrendPost.new
		@page_title = "Kicks4Love Admin | New Trend Post"
	end

	def create
		trend_post = TrendPost.new trend_post_params

		if trend_post.save
			redirect_to admin_trend_posts_path, :notice => "New trend post successfully created"
		else
			redirect_to :back, :alert => "Error creating new trend post"
		end
	end

	def update
		if @trend_post.update_attributes(trend_post_params)
			flash[:notice] = "The trend post has been successfully updated"
		else
			flash[:alert] = "Error occurs while updating the trend post, please try again"
		end

		redirect_to admin_trend_posts_path
	end

	def edit
		@page_title = "Kicks4Love Admin | Edit Trend Post"
	end

	def destroy
		if @trend_post.destroy
			flash[:notice] = "The trend post has been deleted successfully"
		else
			flash[:error] = "Error occurs while deleting the trend post, please try again"
		end

		redirect_to admin_trend_posts_path
	end

	def remove_old
		all_posts = TrendPost.all
		all_done = true
		old_posts = []
		all_posts.each do |post|
			if 3.month.ago.to_i > post.created_at.to_i
				old_posts.push(post)
				unless post.destroy
					all_done = false
					flash[:alert] = "Error occurs while deleting a featured post!"
				end
			end
		end
		if all_done
			flash[:notice] = "All old posts removed successfully!"
		end
		render :json => old_posts.to_json, :layout => false
	end

	private

	def trend_post_params
		params.require(:trend_post).permit(:title_en, :title_cn, :content_en, :content_cn, :main_image, :cover_image)
	end

	def get_trend_post
		@trend_post = TrendPost.find_by_id(params[:id])
	end

end
