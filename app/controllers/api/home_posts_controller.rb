class Api::HomePostsController < Api::ApiBaseController

  def index
    @return_posts = []
    @slider_posts = []

    if params[:next_page].present?
      page_index = 6 * params[:next_page].to_i
      feeds = Post.get_posts(@chinese)
      @no_more = page_index >= feeds.count
      feeds = feeds[page_index - 6.. page_index - 1]
      unless feeds.blank?
        @return_posts.concat(Api::ApiHelper.reformat_feeds(feeds, root_url.chop, true))
        if params[:next_page].to_i == 1 # first request
          @slider_posts = Api::ApiHelper.get_slider_posts(@chinese, root_url.chop)
        end
      end
    else
      @no_more = true
    end

    render json: Api::ApiHelper.json_response(@no_more, @return_posts, @slider_posts), status: :ok
  end

end