class Api::StreetsnapPostsController < Api::ApiBaseController

  def index
    if params[:next_page].present?
      feeds = StreetSnapPost.paginate(:page => params[:next_page], :per_page => 6).latest
      @no_more = feeds.total_pages == feeds.current_page
      if @chinese
        feeds = feeds.select("id, title_cn AS title, content_cn AS content, cover_image, created_at")
      else
        feeds = feeds.select("id, title_en AS title, content_en AS content, cover_image, created_at")
      end
      feeds.each {|feed| feed.content = feed.content.blank? ? "" : YAML.load(feed.content)}
      @return_posts = Api::ApiHelper.reformat_feeds(feeds, root_url.chop, false)
    else
      @no_more = true
      @return_posts = []
    end
    render json: Api::ApiHelper.json_response(@no_more, @return_posts), status: :ok

  end

end
