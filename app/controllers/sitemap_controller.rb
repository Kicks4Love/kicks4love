class SitemapController < ApplicationController

  layout nil

  def index
    headers['Content-Type'] = 'application/xml'
    all_posts = { 
      feature_posts: FeaturePost.all,
      oncourt_posts: OnCourtPost.all,
      streetsnap_posts: StreetSnapPost.all,
      rumor_posts: RumorPost.all,
      trend_posts: TrendPost.all 
    }
    respond_to do |format|
        format.xml { @all_posts = all_posts }
    end
  end

end