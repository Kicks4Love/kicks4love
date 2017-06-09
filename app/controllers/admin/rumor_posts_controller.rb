class Admin::RumorPostsController < Admin::AdminController

	skip_before_filter :verify_authenticity_token, :only => [:destroy]
	before_action :get_rumor_post, :only => [:edit, :destroy, :update, :show]

	def index
		@page_title = "Rumors Posts | Kicks4Love Admin"
		@rumor_posts = RumorPost.latest
		@expired_posts_count = RumorPost.old.size;
		if params[:filter].present?
			session[:rumor_post_per_page] = params[:filter][:per_page].to_i
		end
		@per_page = session[:rumor_post_per_page] || 5
		@feature_posts = @rumor_posts.paginate(:page => params[:page] || 1, :per_page => session[:rumor_post_per_page] || 5)
	end

	def new
		@rumor_post = RumorPost.new
		@page_title = "New Rumor Post | Kicks4Love Admin"
	end

	def create
		rumor_post = RumorPost.new process_content(rumor_post_params)

		rumor_post.author = current_admin_user

		if rumor_post.content_en.count > RumorPost::MAX_NUMBER_ALLOW || rumor_post.content_cn.count > RumorPost::MAX_NUMBER_ALLOW
	      	redirect_to :back, :alert => "Maximum paragraph number is #{RumorPost::MAX_NUMBER_ALLOW}"
	      	return
	    elsif rumor_post.main_images.count > RumorPost::MAX_NUMBER_ALLOW
	      	redirect_to :back, :alert => "Maximum main image number is #{RumorPost::MAX_NUMBER_ALLOW}"
	      	return
	    end

		if rumor_post.save
			redirect_to admin_rumor_posts_path, :notice => "New rumor post successfully created"
		else
			redirect_to :back, :alert => "Error creating new rumor post"
		end
	end

	def update
		params = process_content(rumor_post_params)

		if params[:content_en].count > RumorPost::MAX_NUMBER_ALLOW || params[:content_cn].count > RumorPost::MAX_NUMBER_ALLOW
      		redirect_to :back, :alert => "Maximum paragraph number is #{RumorPost::MAX_NUMBER_ALLOW}"
      		return
    	elsif params[:main_images].present? && params[:main_images].count > RumorPost::MAX_NUMBER_ALLOW
      		redirect_to :back, :alert => "Maximum main image number is #{RumorPost::MAX_NUMBER_ALLOW}"
      		return
    	end
		@rumor_post.author = current_admin_user if @rumor_post.author.nil?
		if @rumor_post.update_attributes(params)
			flash[:notice] = "The rumor post has been successfully updated"
		else
			flash[:alert] = "Error occurs while updating the rumor post, please try again"
		end

		redirect_to admin_rumor_posts_path
	end

	def edit
		@page_title = "Edit Rumor Post | Kicks4Love Admin"
		@rumor_post.content_en = @rumor_post.content_en.map {|p| '>>' + p}
		@rumor_post.content_cn = @rumor_post.content_cn.map {|p| '>>' + p}
	end

	def destroy
		id = @rumor_post.id
		if @rumor_post.delete
			Admin::AdminHelper.remove_uploads_file('rumor_post', id)
			flash[:notice] = "The rumor post has been deleted successfully"
		else
			flash[:alert] = "Error occurs while deleting the rumor post, please try again"
		end

		redirect_to admin_rumor_posts_path
	end

	def remove_old
		old_posts = RumorPost.old
		return_posts = old_posts.to_a
		if old_posts.delete_all
			return_posts.each {|post| Admin::AdminHelper.remove_uploads_file('rumor_post', post.id)}
			render :json => return_posts.to_json, :layout => false
		else
			head :ok, :status => 500
		end
	end

	private

	def rumor_post_params
		params
		.require(:rumor_post)
		.permit(:title_en, :title_cn, :content_en, :content_cn, :cover_image, {main_images: []}, :remove_main_images)
	end

	def process_content(params)
		params[:content_en] = params[:content_en].split(/\r?\n/).map {|p| Admin::AdminHelper.trim_str(p)}
		params[:content_cn] = params[:content_cn].split(/\r?\n/).map {|p| Admin::AdminHelper.trim_str(p)}
    	return params
  	end

	def get_rumor_post
		@rumor_post = RumorPost.find_by_id(params[:id])
	end

end