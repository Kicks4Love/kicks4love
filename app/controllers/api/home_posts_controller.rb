class Api::HomePostsController < ApplicationController

  def index
    if params[:next_page].present?
      logger.debug params[:l]
      @chinese = params[:l] == 'cn';
      page_index = 6 * params[:next_page].to_i
      feeds = Post.get_posts(@chinese)
      @no_more = page_index >= feeds.count
      feeds = feeds[page_index - 6.. page_index - 1]
      feeds.each do |feed|
        case feed.class.name
          when "FeaturePost"
              feed.post_type = "features"
          when "TrendPost"
            feed.post_type = "trend"
          when "OnCourtPost"
              feed.post_type = "oncourt"
          when "StreetSnapPost"
            feed.post_type = "streetsnap"
          when "RumorPost"
            feed.post_type = "rumors"
          end
      end
      @return_posts = Api::ApiHelper.reformat(feeds, root_url.chop)
    else
      @no_more = true
      @return_posts = []
    end
    render json: Api::ApiHelper.json_response(@no_more, @return_posts), status: :ok

  end

end
