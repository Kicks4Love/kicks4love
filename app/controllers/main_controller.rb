class MainController < ApplicationController
	before_action :set_locale, :except => [:change_language]

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
		if @chinese
			@feature_posts = @feature_posts.select("title_cn AS title, content_cn AS content, cover_image, id")
		else
			@feature_posts = @feature_posts.select("title_en AS title, content_en AS content, cover_image, id")
		end
	end

	def feature_show
		@page_title = 'Showing feaure page'
		@feature_post = FeaturePost.find(params[:id])
	end

	def calendar
		@page_title = 'Kicks4Love | Calendar'
	end

	def oncourt
		@page_title = 'Kicks4Love | On Court'
		@on_court_posts = OnCourtPost.latest.paginate(:page => 1)
		if @chinese
			@on_court_posts = @on_court_posts.select("title_cn AS title, content_cn AS content, cover_image, id")
		else
			@on_court_posts = @on_court_posts.select("title_en AS title, content_en AS content, cover_image, id")
		end
	end

	def oncourt_show
		@page_title = 'Showing on court page'
		@oncourt_post = OnCourtPost.find(params[:id])
	end

	def trend
		@page_title= 'Kicks4Love | Trend'
		@all_trend_posts = TrendPost.latest.paginate(:page => 1)
	end

	def trend_show
		@page_title = 'Showing trend page'
		@trend_post = TrendPost.find(params[:id])
	end

	def get_posts
		head :ok and return unless params[:next_page].present?

		case params[:source_page]
		when 'index'
			page_index = 3 * params[:next_page].to_i
			feeds = Post.get_posts(@chinese)
			@no_more = page_index > feeds.count
			feeds = feeds[page_index - 3.. page_index - 1]
		when 'features'
			feeds = FeaturePost.paginate(:page => params[:next_page]).latest
			@no_more = feeds.total_pages == feeds.current_page
			if @chinese
				feeds = feeds.select("id, title_cn AS title, content_cn AS content, cover_image")
			else
				feeds = feeds.select("id, title_en AS title, content_en AS content, cover_image")
			end
		when 'calendar'
			feeds = CalendarPost.where('extract(year from release_date) = ? AND extract(month from release_date) = ?', params[:year], params[:month])
			@no_more = false
			if @chinese
				feeds = feeds.select("id, title_cn AS title, release_date, release_type, cover_image")
			else
				feeds = feeds.select("id, title_en AS title, release_date, release_type, cover_image")
			end
		when 'on_court'
			feeds = OnCourtPost.paginate(:page => params[:next_page]).latest
			@no_more = feeds.total_pages == feeds.current_page
			if @chinese
				feeds = feeds.select("id, title_cn AS title, content_cn AS content, cover_image")
			else
				feeds = feeds.select("id, title_en AS title, content_en AS content, cover_image")
			end
		when 'trend'
			@return_posts = TrendPost.paginate(:page => params[:next_page]).latest
		else
			head :ok and return
		end

		@return_posts = []
		feeds.each do |post|
			post_hash = {:post => post, :image_url => post.cover_image.main.url}
			@return_posts.push(post_hash)
		end

		render :json => {:no_more => @no_more, :posts => @return_posts}.to_json, :layout => false
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
