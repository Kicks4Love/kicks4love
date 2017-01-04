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

	def calendar
		@page_title = 'Kicks4Love | Calendar'
	end

	def oncourt
		@page_title = 'Kicks4Love | On Court'
		@all_on_court_posts = OnCourtPost.latest.paginate(:page => 1)
	end

	def trend
		@page_title= 'Kicks4Love | Trend'
		@all_trend_posts = TrendPost.latest.paginate(:page => 1)
	end

	def get_posts
		head :ok and return unless params[:next_page].present?

		case params[:source_page]
		when 'index'
			@return_posts = Post.where(:post_type => :POST).paginate(:page => params[:next_page]).latest
		when 'features'
			@return_posts = FeaturePost.paginate(:page => params[:next_page]).latest
		when 'on_court'
			@return_posts = OnCourtPost.paginate(:page => params[:next_page]).latest
		when 'trend'
			@return_posts = TrendPost.paginate(:page => params[:next_page]).latest
		else
			head :ok and return
		end

		render :json => {:no_more => @return_posts.total_pages == @return_posts.current_page, :posts => @return_posts}.to_json, :layout => false
	end

end
