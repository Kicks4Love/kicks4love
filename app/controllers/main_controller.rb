class MainController < ApplicationController
	before_action :set_locale, :except => [:get_posts, :change_language]

	def index
		all_posts = Post.order(:created_at => :DESC)
		@news = all_posts.news
		@posts = all_posts.posts 

		if @chinese
			@news = @news.select("title_cn AS title, image, pointer_id")
			@posts = @posts.select("title_cn AS title, image, pointer_id")
		else
			@news = @news.select("title_en AS title, image, pointer_id")
			@posts = @posts.select("title_en AS title, image, pointer_id")
		end

		all_feeds = Post.get_posts(@chinese)
		@no_more = 3 > all_feeds.count
		@feeds = all_feeds[0..2]
	end

	def features
		@page_title = 'Kicks4Love | Features'
		@feature_posts = FeaturePost.latest.paginate(:page => 1)
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
			page_index = 3 * params[:next_page].to_i
			feeds = Post.get_posts(session[:language] == :cn)
			@no_more = page_index > feeds.count
			@return_posts = feeds[page_index - 3.. page_index - 1]
		when 'features'
			@return_posts = FeaturePost.paginate(:page => params[:next_page]).latest
		when 'on_court'
			@return_posts = OnCourtPost.paginate(:page => params[:next_page]).latest
		when 'trend'
			@return_posts = TrendPost.paginate(:page => params[:next_page]).latest
		else
			head :ok and return
		end

		render :json => {:no_more => (defined? @no_more) ? @no_more : @return_posts.total_pages == @return_posts.current_page, :posts => @return_posts}.to_json, :layout => false
	end

	def change_language 
		redirect_to :back and return unless params[:language].present?

		I18n.locale = params[:language][:chinese].present? ? :cn : :en
		session[:language] = I18n.locale

		redirect_to :back
	end

	private

	def set_locale
  		I18n.locale = session[:language] || I18n.default_locale
  		@chinese = session[:language] == "cn"
	end 

end