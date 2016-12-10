class MainController < ApplicationController

	def index
		all_posts = Post.order(:created_at => :DESC)
		@news_posts = all_posts.where(:post_type => :NEWS)
		@regular_posts = all_posts.where(:post_type => :POST).paginate(:page => 1)
	end

	def features
		@page_title = 'Kicks4Love | Features'
		@feature_posts = FeaturePost.order(:created_at => :DESC).paginate(:page => 1)
	end

	def oncourt
		@page_title = 'Kicks4Love | On Court'
		@all_on_court_posts = OnCourtPost.latest.limit(6)
	end


	def get_posts
		head :ok and return unless params[:next_page].present?

		case params[:source_page]
		when 'index'
			@return_posts = Post.where(:post_type => :POST).paginate(:page => params[:next_page]).order(:created_at => :DESC)
		when 'features'
			@return_posts = FeaturePost.paginate(:page => params[:next_page]).order(:created_at => :DESC)
		when 'oncourt'
			@regular_posts = OnCourtPost.latest.paginate(:page => params[:next_page])
		else
			head :ok and return
		end

		render :json => {:no_more => @return_posts.total_pages == @return_posts.current_page, :posts => @return_posts}.to_json, :layout => false
	end

end
