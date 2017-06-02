class SitemapController < ApplicationController
  
  layout nil

  def index
    headers['Content-Type'] = 'application/xml'
    respond_to do |format|
        format.xml {@feature_post = FeaturePost.last}
    end
  end

end