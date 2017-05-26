class MainController < ApplicationController

	before_action :set_locale, :except => [:change_language]

	def index
		all_posts = Post.latest
		@news = all_posts.news
		@posts = all_posts.posts

		all_feeds = Post.get_posts(@chinese)
		@no_more = 3 >= all_feeds.count
		@feeds = all_feeds[0..2]
	end

	def search
		@page_title = 'Kicks4Love鞋侣 | Search搜索'
		query = {
			query: {
                multi_match: {
                    query: params[:q].present? ? params[:q].strip : '*',
                    type:  'best_fields',
                    fields: ['title_en^10', 'title_cn^10', 'content_cn', 'content_en'],
                    operator: 'or',
                    zero_terms_query: 'all'
                }
            }, highlight: { fields: {:'*' => {}} }
        }
		@results = Elasticsearch::Model.search(query, [FeaturePost, OnCourtPost, TrendPost, CalendarPost]).page(params[:page] || 1).per_page(10).results
	end

	def features
		@page_title = 'Kicks4Love鞋侣 | Features专题'
		@feature_posts = FeaturePost.latest.paginate(:page => 1)
		if @chinese
			@feature_posts = @feature_posts.select("title_cn AS title, content_cn AS content, cover_image, id, created_at")
		else
			@feature_posts = @feature_posts.select("title_en AS title, content_en AS content, cover_image, id, created_at")
		end
		@feature_posts.each {|feature_post| feature_post.content = helpers.serialized_array_string_to_array(feature_post.content)}
	end

	def feature_show
		@feature_post = FeaturePost.find(params[:id])
		if @chinese
			@category = '专题'
			@page_title = "#{@feature_post.title_cn} #{@feature_post.title_en}"
			@article_title = @feature_post.title_cn
			@content = @feature_post.content_cn
		else
			@category = 'Features'
			@page_title = "#{@feature_post.title_en} #{@feature_post.title_cn}"
			@article_title = @feature_post.title_en
			@content = @feature_post.content_en
		end
		@og_image = "http://#{request.host}#{@feature_post.cover_image.url}"
	end

	def calendar
		@page_title = 'Kicks4Love鞋侣 | Calendar日历'
	end

	def trend
		@page_title= 'Kicks4Love鞋侣 | Trend潮流'
		@all_trend_posts = TrendPost.latest.paginate(:page => 1)
		if @chinese
			@all_trend_posts = @all_trend_posts.select("title_cn AS title, cover_image, id, created_at")
		else
			@all_trend_posts = @all_trend_posts.select("title_en AS title, cover_image, id, created_at")
		end
	end

	def trend_show
		@trend_post = TrendPost.find(params[:id])
		if @chinese
			@category = '潮流趋势'
			@page_title = "#{@trend_post.title_cn} #{@trend_post.title_en}"
			@article_title = @trend_post.title_cn
			@content = @trend_post.content_cn
		else
			@category = 'Trend'
			@page_title = "#{@trend_post.title_en} #{@trend_post.title_cn}"
			@article_title = @trend_post.title_en
			@content = @trend_post.content_en
		end
		@times = [@content.size, @trend_post.main_images.size].max
		@og_image = "http://#{request.host}#{@trend_post.cover_image.url}"
	end

	def oncourt
		@page_title = 'Kicks4Love鞋侣 | On Court球场'
		@on_court_posts = OnCourtPost.latest.paginate(:page => 1)
		if @chinese
			@on_court_posts = @on_court_posts.select("title_cn AS title, player_name_cn AS player_name, content_en, content_cn, main_images, cover_image, id, created_at")
		else
			@on_court_posts = @on_court_posts.select("title_en AS title, player_name_en AS player_name, content_en, content_cn, main_images, cover_image, id, created_at")
		end
	end

	def oncourt_show
		@oncourt_post = OnCourtPost.find(params[:id])
		if @chinese
			@category = '球场时装'
			@page_title = "#{@oncourt_post.title_cn} #{@oncourt_post.title_en}"
			@article_title = @oncourt_post.title_cn
			@content = @oncourt_post.content_cn
		else
			@category = 'On Court'
			@page_title = "#{@oncourt_post.title_en} #{@oncourt_post.title_cn}"
			@article_title = @oncourt_post.title_en
			@content = @oncourt_post.content_en
		end
		@times = [@content.size, @oncourt_post.main_images.size].max
		@og_image = "http://#{request.host}#{@oncourt_post.cover_image.url}"
	end

	def terms
		@page_title = 'Kicks4Love鞋侣 | Terms条款'
	end

	def contact
		@page_title = 'Kicks4Love鞋侣 | Contact Us联系我们'
		if @chinese
			@contact_placeholder = {
				:first_name_label => "名字",
				:first_name_placeholder => "冠希",
				:last_name_label => "姓氏",
				:last_name_placeholder => "陈",
				:email_label => "邮件",
				:email_placeholder => "edison.chen@hotmail.com",
				:comments_label => "想法和评论",
				:enter_message => "或按下 <strong>回车键</strong>"
			}
		else
			@contact_placeholder = {
				:first_name_label => "first name",
				:first_name_placeholder => "Kim",
				:last_name_label => "last name",
				:last_name_placeholder => "Kardashian",
				:email_label => "email",
				:email_placeholder => "kim.kardashian@hotmail.com",
				:comments_label => "comments",
				:enter_message => "or press <strong>enter</strong>"
			}
		end
	end

	def send_contact_us
		begin
			email_options = {
				:first_name => params[:first_name],
				:last_name => params[:last_name],
				:chinese => @chinese,
				:comment => params[:comments]
			}
			CustomerServiceMailer.send_contact_email(params[:email], email_options).deliver_now
			flash[:notice] = @chinese ? "信息发送成功" : "Your message sent successfully"
		rescue
			flash[:alert] = @chinese ? "错误发生当发送您的信息，请重试一遍" : "Error occurs while sending your message, please try again"
		end

		redirect_to :back
	end

	def get_posts
		head :ok and return unless params[:next_page].present?

		case params[:source_page]
		when 'index'
			page_index = 3 * params[:next_page].to_i
			feeds = Post.get_posts(@chinese)
			@no_more = page_index >= feeds.count
			feeds = feeds[page_index - 3.. page_index - 1]
			feeds.each do |feed|
				case feed.class.name
                when "FeaturePost"
                  	feed.post_type = "features"
              	when "TrendPost"
              		feed.post_type = "trend"
                when "OnCourtPost"
                  	feed.post_type = "oncourt"
                end
			end
		when 'features'
			feeds = FeaturePost.paginate(:page => params[:next_page]).latest
			@no_more = feeds.total_pages == feeds.current_page
			if @chinese
				feeds = feeds.select("id, title_cn AS title, content_cn AS content, cover_image, created_at")
			else
				feeds = feeds.select("id, title_en AS title, content_en AS content, cover_image, created_at")
			end
			feeds.each {|feed| feed.content = helpers.serialized_array_string_to_array(feed.content)}
		when 'calendar'
			feeds = CalendarPost.where('extract(year from release_date) = ? AND extract(month from release_date) = ?', params[:year], params[:month])
			@no_more = false
			if @chinese
				feeds = feeds.select("id, title_cn AS title, release_date, release_type, rmb AS price, cover_image")
			else
				feeds = feeds.select("id, title_en AS title, release_date, release_type, usd AS price, cover_image")
			end
		when 'on_court'
			feeds = OnCourtPost.paginate(:page => params[:next_page]).latest
			@no_more = feeds.total_pages == feeds.current_page
			if @chinese
				feeds = feeds.select("id, title_cn AS title, player_name_cn AS player_name, content_en, content_cn, main_images, cover_image, created_at")
			else
				feeds = feeds.select("id, title_en AS title, player_name_en AS player_name, content_en, content_cn, main_images, cover_image, created_at")
			end
		when 'trend'
			feeds = TrendPost.paginate(:page => params[:next_page]).latest
			@no_more = feeds.total_pages == feeds.current_page
			if @chinese
				feeds = feeds.select("id, title_cn AS title, cover_image, created_at")
			else
				feeds = feeds.select("id, title_en AS title, cover_image, created_at")
			end
		else
			head :ok and return
		end

		@return_posts = []
		feeds.each do |post|
			post_hash = {:post => post, :image_url => post.cover_image.url}
			post_hash[:post_type] = post.post_type if (defined? post.post_type)
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
