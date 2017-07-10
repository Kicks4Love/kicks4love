class Api::OncourtPostsController < Api::ApiBaseController

  def index
    if params[:next_page].present?
      feeds = OnCourtPost.paginate(:page => params[:next_page], :per_page => 6).latest
      @no_more = feeds.total_pages == feeds.current_page
      if @chinese
        feeds = feeds.select("id, title_cn AS title, player_name_cn AS player_name, content_cn AS content, cover_image, created_at")
      else
        feeds = feeds.select("id, title_en AS title, player_name_en AS player_name, content_en AS content, cover_image, created_at")
      end
      feeds.each {|feed| feed.content = feed.content.blank? ? "" : YAML.load(feed.content)}
      @return_posts = Api::ApiHelper.reformat_feeds(feeds, root_url.chop, false)
    else
      @no_more = true
      @return_posts = []
    end
    render json: Api::ApiHelper.json_response(@no_more, @return_posts), status: :ok

  end

  def show
    begin
      post = OnCourtPost.find(params[:id])
      render json: { post: post }.to_json, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: e.message }.to_json, status: :not_found
    end
  end

end
