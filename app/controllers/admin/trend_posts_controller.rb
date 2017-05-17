class Admin::TrendPostsController < Admin::AdminController
	skip_before_filter :verify_authenticity_token, :only => [:destroy]
	before_action :get_trend_post, :only => [:edit, :destroy, :update, :show]

	def index
		@page_title = "Kicks4Love Admin | Trend Posts"
		@trend_posts = TrendPost.latest
		@expired_posts_count = TrendPost.old.size;
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
		trend_post = TrendPost.new process_content(trend_post_params)

		if trend_post.content_en.count > 6 || trend_post.content_cn.count > 6
	      redirect_to :back, :alert => "Maximum paragraph number is 6"
	      return
	    elsif trend_post.main_images.count > 6
	      redirect_to :back, :alert => "Maximum main image number is 6"
	      return
	    end

		if trend_post.save
			redirect_to admin_trend_posts_path, :notice => "New trend post successfully created"
		else
			redirect_to :back, :alert => "Error creating new trend post"
		end
	end

	def update
		params = process_content(trend_post_params)

		if params[:content_en].count > 6 || params[:content_cn].count > 6
      		redirect_to :back, :alert => "Maximum paragraph number is 6"
      		return
    	elsif params[:main_images].present? && params[:main_images].count > 6
      		redirect_to :back, :alert => "Maximum main image number is 6"
      		return
    	end

		if @trend_post.update_attributes(params)
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
		old_posts = TrendPost.old
		return_posts = old_posts.to_a
		if old_posts.delete_all
			render :json => return_posts.to_json, :layout => false
		else
			head :ok, :status => 500
		end
	end

	private

	def trend_post_params
		params.require(:trend_post)
		.permit(:title_en, :title_cn, :content_en, :content_cn, :cover_image, {main_images: []})
	end

	def process_content(params)
		params[:content_en] = params[:content_en].split(/\r?\n/)
		params[:content_cn] = params[:content_cn].split(/\r?\n/)
    	return params
  	end

	def get_trend_post
		@trend_post = TrendPost.find_by_id(params[:id])
	end

end