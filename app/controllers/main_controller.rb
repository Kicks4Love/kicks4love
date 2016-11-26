class MainController < ApplicationController

	def index
		all_posts = Post.order(:created_at => :DESC)
		@news_posts = all_posts.where(:post_type => :NEWS)
		@regular_posts = all_posts.where(:post_type => :POST).limit(3)
	end

	def features
		@page_title = 'Kicks4Love | Features'
		all_feature_posts = FeaturePost.order(:created_at => :DESC).limit(3)
	end


	def get_posts
		render :nothing => true and return unless params[:index].present?

		return_posts = []
		no_more = false

		case params[:source_page]
		when 'main'
			@regular_posts = Post.where(:post_type => :POST).order(:created_at => :DESC)

			@regular_posts.each_with_index { |post, index| 
				next if index < params[:index].to_i || index > params[:index].to_i + 2
				no_more = @regular_posts[index+1].nil?
				return_posts << post
			}
		when 'features'
		end

		render :json => {:no_more => no_more, :posts => return_posts}.to_json, :layout => false
	end

end
