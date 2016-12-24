class Admin::FeaturePostsController < Admin::AdminController

	skip_before_filter :verify_authenticity_token, :only => [:destroy]
	before_action :get_feature_post, :only => [:edit, :destroy, :update, :show]

	def index
		@page_title = "Kicks4Love Admin | Feature Posts"
		@feature_posts = FeaturePost.all.order(:created_at => :DESC)

		if params[:filter].present?
			session[:feature_post_per_page] = params[:filter][:per_page].to_i
		end
		@per_page = session[:feature_post_per_page] || 10
		@feature_posts = @feature_posts.paginate(:page => params[:page] || 1, :per_page => session[:feature_post_per_page] || 10)
	end

	def new
		@feature_post = FeaturePost.new
		@image_list = Dir.glob("#{Rails.root}/app/assets/images/feature_post/*").map{|path| path.split('/').last}
		@page_title = "Kicks4Love Admin | New Feature Post"
	end

	def create
		feature_post = FeaturePost.new feature_post_params

		if feature_post.save
			redirect_to admin_feature_posts_path, :notice => "New feature post successfully created"
		else
			redirect_to :back, :error => "Error creating new feature post"
		end
	end

	def update
		if @feature_post.update_attributes(feature_post_params)
			flash[:notice] = "The feature post has been successfully updated"
		else
			flash[:error] = "Error occurs while updating the feature post, please try again"
		end

		redirect_to admin_feature_posts_path
	end

	def edit
		@image_list = Dir.glob("#{Rails.root}/app/assets/images/feature_post/*").map{|path| path.split('/').last}
		@page_title = "Kicks4Love Admin | Edit Feature Post"
	end

	def destroy
		if @feature_post.destroy
			flash[:notice] = "The feature_post has been deleted successfully"
		else
			flash[:error] = "Error occurs while deleting the featire post, please try again"
		end

		redirect_to admin_feature_posts_path
	end

	private 

	def feature_post_params
		params.require(:feature_post).permit(:title, :content, :image)
	end

	def get_feature_post
		@feature_post = FeaturePost.find_by_id(params[:id])
	end

end