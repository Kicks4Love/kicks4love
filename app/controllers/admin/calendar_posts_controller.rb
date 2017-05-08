class Admin::CalendarPostsController < Admin::AdminController
	skip_before_filter :verify_authenticity_token, :only => [:destroy]
	before_action :get_calendar_post, :only => [:edit, :destroy, :update, :show]
# expired time is 1 month: 2630000 (seconds)
	def index
		@page_title = "Kicks4Love Admin | Calendar Posts"
		@calendar_posts = CalendarPost.latest
		@expired_posts_count = 0;
	  @calendar_posts.each do |post|
	 	 if 1.month.ago.to_i > post.release_date.to_time.to_i # more then 1 month old posts are marked 'expired'
	 		 @expired_posts_count+=1
	 	 end
	  end
 		if params[:filter].present?
 			if params[:filter][:release_type].present?
 				@calendar_posts = @calendar_posts.where(:release_type => params[:filter][:release_type]).latest
 			end
 			session[:calendar_post_per_page] = params[:filter][:per_page].to_i
 		end

		@per_page = session[:calendar_post_per_page] || 5
		@calendar_posts = @calendar_posts.paginate(:page => params[:page] || 1, :per_page => session[:calendar_post_per_page] || 5)
	end

	def new
		@calendar_post = CalendarPost.new
		@page_title = "Kicks4Love Admin | New Calendar Post"
	end

	def create
		calendar_post = CalendarPost.new calendar_post_params

		if calendar_post.save
			redirect_to admin_calendar_posts_path, :notice => "New calendar post successfully created"
		else
			redirect_to :back, :alert => "Error creating new calendar post"
		end
	end

	def update
		if @calendar_post.update_attributes(calendar_post_params)
			flash[:notice] = "The calendar post has been successfully updated"
		else
			flash[:alert] = "Error occurs while updating the calendar post, please try again"
		end

		redirect_to admin_calendar_posts_path
	end

	def edit
		@page_title = "Kicks4Love Admin | Edit Calendar Post"
	end

	def destroy
		if @calendar_post.destroy
			flash[:notice] = "The calendar post has been deleted successfully"
		else
			flash[:alert] = "Error occurs while deleting the calendar post, please try again"
		end

		redirect_to admin_calendar_posts_path
	end

	def remove_old
		all_posts = CalendarPost.all
		all_done = true
		old_posts = []
		all_posts.each do |post|
			if 1.month.ago.to_i > post.release_date.to_time.to_i # more then 3 months old posts are marked 'expired'
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

	def calendar_post_params
		params.require(:calendar_post).permit(:title_en, :title_cn, :content_en, :release_date, :release_type, :usd, :rmb, :cover_image)
	end

	def get_calendar_post
		@calendar_post = CalendarPost.find_by_id(params[:id])
	end
end
