class Admin::FeaturePostsController < Admin::AdminController

	skip_before_filter :verify_authenticity_token, :only => [:destroy]
	before_action :get_feature_post, :only => [:edit, :destroy, :update, :show]

	def index
		@page_title = "Kicks4Love Admin | Feature Posts"
		@feature_posts = FeaturePost.latest
		@expired_posts_count = FeaturePost.old.size;
		if params[:filter].present?
			session[:feature_post_per_page] = params[:filter][:per_page].to_i
		end
		@per_page = session[:feature_post_per_page] || 5
		@feature_posts = @feature_posts.paginate(:page => params[:page] || 1, :per_page => session[:feature_post_per_page] || 5)
	end

	def new
		@feature_post = FeaturePost.new
		@page_title = "Kicks4Love Admin | New Feature Post"
	end

	def create
		feature_post = FeaturePost.new process_content(feature_post_params)

		feature_post.author = current_admin_user

		if feature_post.content_en.count > FeaturePost::MAX_NUMBER_ALLOW  || feature_post.content_cn.count > FeaturePost::MAX_NUMBER_ALLOW
	      	redirect_to :back, :alert => "Maximum paragraph number is #{FeaturePost::MAX_NUMBER_ALLOW}"
	      	return
	    elsif feature_post.main_images.count > FeaturePost::MAX_NUMBER_ALLOW
	      	redirect_to :back, :alert => "Maximum main image number is #{FeaturePost::MAX_NUMBER_ALLOW}"
	      	return
	    end

		if feature_post.save
			redirect_to admin_feature_posts_path, :notice => "New feature post successfully created"
		else
			redirect_to :back, :alert => "Error creating new feature post"
		end
	end

	def update
		params = process_content(feature_post_params)

		if params[:content_en].count > FeaturePost::MAX_NUMBER_ALLOW || params[:content_cn].count > FeaturePost::MAX_NUMBER_ALLOW
      		redirect_to :back, :alert => "Maximum paragraph number is #{FeaturePost::MAX_NUMBER_ALLOW}"
      		return
    	elsif params[:main_images].present? && params[:main_images].count > FeaturePost::MAX_NUMBER_ALLOW
      		redirect_to :back, :alert => "Maximum main image number is #{FeaturePost::MAX_NUMBER_ALLOW}"
      		return
    	end
		if @feature_post.author.nil?
			@feature_post.author = current_admin_user
		end
		if @feature_post.update_attributes(params)
			flash[:notice] = "The feature post has been successfully updated"
		else
			flash[:alert] = "Error occurs while updating the feature post, please try again"
		end

		redirect_to admin_feature_posts_path
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