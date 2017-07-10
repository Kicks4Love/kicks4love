module Api::ApiHelper

  def self.reformat(original_feeds, root_url)
    @return_posts = []
		original_feeds.each do |post|
      full_img_url = root_url + post.cover_image.url
			post_hash = {:post => post, :image_url => full_img_url}
			post_hash[:score] = (post.rates.average(:score) || 0).round(1) if (defined? post.rates)
			post_hash[:post_type] = post.post_type if (defined? post.post_type)
			@return_posts.push(post_hash)
		end
    return @return_posts
  end

  def self.json_response(no_more, posts)
    return {:no_more => no_more, :posts => posts}.to_json
  end

end
