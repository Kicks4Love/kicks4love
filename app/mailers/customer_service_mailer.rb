class CustomerServiceMailer < ApplicationMailer
	# options include first_name, last_name, chinese and comment
	def send_contact_email(email, options={})
	  	@contact_information = {:email => email}.merge(options)
	  	I18n.locale = options[:chinese] ? :zh : :en
	  	mail(:to => email, :subject => I18n.t("contact_us_email_subject"), :bcc => [Rails.application.config.email_list[:leon], Rails.application.config.email_list[:robin]])
	end

	def newsletter(recipients)
		@news = Post.latest.news
		@posts = Post.latest.posts
		subject = @posts.first.title_en + ' | ' + @posts.first.title_cn
		mail(:to => recipients.pluck(:email), :subject => subject)
	end

end
