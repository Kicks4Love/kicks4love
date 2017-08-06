class Api::HomePostsController < Api::ApiBaseController

  def index
    if params[:next_page].present?
      logger.debug params[:l]
      page_index = 6 * params[:next_page].to_i
      feeds = Post.get_posts(@chinese)
      @no_more = page_index >= feeds.count
      feeds = feeds[page_index - 6.. page_index - 1]
      feeds.each do |feed|
        feed = Api::ApiHelper.set_post_type(feed)
      end
      @return_posts = Api::ApiHelper.reformat_feeds(feeds, root_url.chop)
    else
      @no_more = true
      @return_posts = []
    end
    render json: Api::ApiHelper.json_response(@no_more, @return_posts), status: :ok

  end

end
