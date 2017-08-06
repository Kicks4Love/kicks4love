module Api::ApiHelper

  def self.reformat_feeds(original_feeds, root_url, is_index=false)
    @return_posts = []
    original_feeds.each do |post|
      post_hash = format_post(post, root_url)
      if is_index
        post_hash[:post_type] = post.post_type if (defined? post.post_type)
      end
      @return_posts.push(post_hash)
    end
    return @return_posts
  end

  def self.format_post(post, root_url)
    full_img_url = root_url + post.cover_image.url
    post_hash = {:post => post, :image_url => full_img_url}
    post_hash[:score] = (post.rates.average(:score) || 0).round(1) if (defined? post.rates)
    unless !defined?(post.main_images) || post.main_images.blank?
      full_imgs = []
      post.main_images.each do |image|
        full_img_url = root_url + image.url
        full_imgs.push( { url: full_img_url } )
      end
      post_hash[:main_images] = full_imgs
    end
    return post_hash
  end

  def self.get_slider_posts(chinese, root_url)
    if chinese
      posts = Post.posts.select("id, title_cn AS title, image, created_at, pointer_type, pointer_id, post_type")
    else
      posts = Post.posts.select("id, title_en AS title, image, created_at, pointer_type, pointer_id, post_type")
    end
    @slider_posts = []
    posts.each do |post|
      full_img_url = root_url + post.image.url
      slider_post = { post: post, image_url: full_img_url }
      @slider_posts.push(slider_post)
    end
    return @slider_posts
  end

  def self.json_response(no_more, posts, slider_posts=[])
    response = {:no_more => no_more, :posts => posts}
    response[:slider_posts] = slider_posts unless slider_posts.empty?
    return response.to_json
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
