class Admin::TrendPostsController < Admin::AdminController
	
	skip_before_filter :verify_authenticity_token, :only => [:destroy]
	before_action :get_trend_post, :only => [:edit, :destroy, :update, :show]

	def index
		@page_title = "Trend Posts | Kicks4Love Admin"
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
		@page_title = "New Trend Post | Kicks4Love Admin"
	end

	def create
		trend_post = TrendPost.new process_content(trend_post_params)
		trend_post.author = current_admin_user

		if trend_post.content_en.count > TrendPost::MAX_NUMBER_ALLOW || trend_post.content_cn.count > TrendPost::MAX_NUMBER_ALLOW
	      redirect_to :back, :alert => "Maximum paragraph number is #{TrendPost::MAX_NUMBER_ALLOW}"
	      return
	    elsif trend_post.main_images.count > TrendPost::MAX_NUMBER_ALLOW
	      redirect_to :back, :alert => "Maximum main image number is #{TrendPost::MAX_NUMBER_ALLOW}"
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

		if params[:content_en].count > TrendPost::MAX_NUMBER_ALLOW || params[:content_cn].count > TrendPost::MAX_NUMBER_ALLOW
      		redirect_to :back, :alert => "Maximum paragraph number is #{TrendPost::MAX_NUMBER_ALLOW}"
      		return
    	elsif params[:main_images].present? && params[:main_images].count > TrendPost::MAX_NUMBER_ALLOW
      		redirect_to :back, :alert => "Maximum main image number is #{TrendPost::MAX_NUMBER_ALLOW}"
      		return
    	end
		@trend_post.author = current_admin_user if @trend_post.author.nil?
		if @trend_post.update_attributes(params)
			flash[:notice] = "The trend post has been successfully updated"
		else
			flash[:alert] = "Error occurs while updating the trend post, please try again"
		end

		redirect_to admin_trend_posts_path
	end

	def edit
		@page_title = "Edit Trend Post | Kicks4Love Admin"
		@trend_post.content_en = @trend_post.content_en.map {|p| '>>' + p}
		@trend_post.content_cn = @trend_post.content_cn.map {|p| '>>' + p}
	end

	def destroy
		id = @trend_post.id
		if @trend_post.delete
			Admin::AdminHelper.remove_uploads_file('trend_post', id)
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
			return_posts.each {|post| Admin::AdminHelper.remove_uploads_file('trend_post', post.id)}
			render :json => return_posts.to_json, :layout => false
		else
			head :ok, :status => 500
		end
	end

	private

	def trend_post_params
		params.require(:trend_post)
		.permit(:title_en, :title_cn, :content_en, :content_cn, :cover_image, {main_images: []}, :remove_main_images)
	end

	def process_content(params)
		params[:content_en] = params[:content_en].split(/\r?\n/).map {|p| Admin::AdminHelper.trim_str(p)}
		params[:content_cn] = params[:content_cn].split(/\r?\n/).map {|p| Admin::AdminHelper.trim_str(p)}
    	return params
  	end

	def get_trend_post
		@trend_post = TrendPost.find_by_id(params[:id])
	end

end