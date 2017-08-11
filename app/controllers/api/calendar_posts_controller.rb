class Api::CalendarPostsController < Api::ApiBaseController

  def index
    @return_posts = []

    if params[:year].present? && params[:month].present?
      feeds = CalendarPost.where('extract(year from release_date) = ? AND extract(month from release_date) = ?', params[:year], params[:month])
      if @chinese
        feeds = feeds.select("id, title_cn AS title, release_date, release_type, rmb AS price, cover_image")
      else
        feeds = feeds.select("id, title_en AS title, release_date, release_type, usd AS price, cover_image")
      end
      @return_posts = Api::ApiHelper.reformat_feeds(feeds, root_url.chop)
    end

    render json: { posts: @return_posts }.to_json, status: :ok
  end

end