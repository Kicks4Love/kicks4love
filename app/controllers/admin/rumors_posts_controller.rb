class Admin::RumorsPostsController < Admin::AdminController

	skip_before_filter :verify_authenticity_token, :only => [:destroy]
	before_action :get_feature_post, :only => [:edit, :destroy, :update, :show]

	def index
		@page_title = "Kicks4Love Admin | Rumors Posts"
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
		@page_title = "Kicks4Love Admin | New Rumor Post"
	end

	def create
		rumor_post = RumorPost.new process_content(rumor_post_params)

		rumor_post.author = current_admin_user

		if rumor_post.content_en.count > 5 || rumor_post.content_cn.count > 5
	      	redirect_to :back, :alert => "Maximum paragraph number is 5"
	      	return
	    elsif rumor_post.main_images.count > 5
	      	redirect_to :back, :alert => "Maximum main image number is 5"
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

		if params[:content_en].count > 5 || params[:content_cn].count > 5
      		redirect_to :back, :alert => "Maximum paragraph number is 5"
      		return
    	elsif params[:main_images].present? && params[:main_images].count > 5
      		redirect_to :back, :alert => "Maximum main image number is 5"
      		return
    	end
		if @rumor_post.author.nil?
			@rumor_post.author = current_admin_user
		end
		if @rumor_post.update_attributes(params)
			flash[:notice] = "The rumor post has been successfully updated"
		else
			flash[:alert] = "Error occurs while updating the rumor post, please try again"
		end

		redirect_to admin_rumor_posts_path
	end

	def edit
		@page_title = "Kicks4Love Admin | Edit Feature Post"
	end

	def destroy
		if @feature_post.destroy
			flash[:notice] = "The feature_post has been deleted successfully"
		else
			flash[:alert] = "Error occurs while deleting the feature post, please try again"
		end

		redirect_to admin_feature_posts_path
	end

	def remove_old
		old_posts = FeaturePost.old
		return_posts = old_posts.to_a
		if old_posts.delete_all
			render :json => return_posts.to_json, :layout => false
		else
			head :ok, :status => 500
		end
	end

	private

	def feature_post_params
		params
		.require(:feature_post)
		.permit(:title_en, :title_cn, :content_en, :content_cn, :cover_image, {main_images: []}, :remove_main_images, :post_composition)
	end

	def process_content(params)
		params[:content_en] = params[:content_en].split(/\r?\n/)
		params[:content_cn] = params[:content_cn].split(/\r?\n/)
		params[:post_composition] = JSON.parse params[:post_composition]
    	return params
  	end

	def get_feature_post
		@feature_post = FeaturePost.find_by_id(params[:id])
	end
end
