module Api::ApiHelper

  def self.reformat_feeds(original_feeds, root_url, is_index=true)
    @return_posts = []
    original_feeds.each do |post|
      full_img_url = root_url + post.cover_image.url
      post_hash = {:post => post, :image_url => full_img_url}
      post_hash[:score] = (post.rates.average(:score) || 0).round(1) if (defined? post.rates)
      if is_index
        post_hash[:post_type] = post.post_type if (defined? post.post_type)
      end
      @return_posts.push(post_hash)
    end
    return @return_posts
  end

  def self.json_response(no_more, posts)
    return {:no_more => no_more, :posts => posts}.to_json
  end

  def self.set_post_type(post)
    case post.class.name
    when "FeaturePost"
      post.post_type = "features"
    when "TrendPost"
      post.post_type = "trend"
    when "OnCourtPost"
      post.post_type = "oncourt"
    when "StreetSnapPost"
      post.post_type = "streetsnap"
    when "RumorPost"
      post.post_type = "rumors"
    end
    return post
  end

end
