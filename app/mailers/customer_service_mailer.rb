class CustomerServiceMailer < ApplicationMailer
	# options include first_name, last_name, chinese and comment
	def send_contact_email(email, options={})
	  	@contact_information = {:email => email}.merge(options)
	  	I18n.locale = options[:chinese] ? :zh : :en
	  	mail(:to => email, :subject => I18n.t("contact_us_email_subject"), :bcc => [Rails.application.config.email_list[:leon], Rails.application.config.email_list[:robin]])
	end

	def newsletter(email, first_section, second_section)
		@news = first_section
		@posts = second_section
		subject = @posts.first.title_en + ' | ' + @posts.first.title_cn
		mail(:to => email, :subject => subject)
	end

	def self.send_newsletter(recipients)
		news_posts = Post.latest.news
		headline_posts = Post.latest.posts
		recipients.each do |recipient|
			newsletter(recipient.email, news_posts, headline_posts).deliver
		end
	end

end
