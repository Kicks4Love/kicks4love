class Api::TrendPostsController < Api::ApiBaseController

  def index
    @return_posts = []
    if params[:next_page].present?
      feeds = TrendPost.paginate(:page => params[:next_page], :per_page => 6).latest
      @no_more = feeds.total_pages <= feeds.current_page
      unless feeds.blank?
        if @chinese
          feeds = feeds.select("id, title_cn AS title, cover_image, created_at")
        else
          feeds = feeds.select("id, title_en AS title, cover_image, created_at")
        end
        @return_posts = Api::ApiHelper.reformat_feeds(feeds, root_url.chop)
      end
    else
      @no_more = true
    end
    render json: Api::ApiHelper.json_response(@no_more, @return_posts), status: :ok

  end

  def show
    begin
      post = TrendPost.find(params[:id])
      return_post = Api::ApiHelper.format_post(post, root_url.chop)
      render json: return_post.to_json, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: e.message }.to_json, status: :not_found
    end
  end

end
