class SitemapController < ApplicationController
  layout nil

  def index
    headers['Content-Type'] = 'application/xml'
    feature_posts = FeaturePost.latest
    respond_to do |format|
      unless feature_posts.blank?
        format.xml {@feature_post = feature_posts[0]}
      end
    end
  end

end
