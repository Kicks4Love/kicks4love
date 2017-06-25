class CustomerServiceMailer < ApplicationMailer
	# options include first_name, last_name, chinese and comment
	def send_contact_email(email, options={})
	  	@contact_information = {:email => email}.merge(options)
	  	I18n.locale = options[:chinese] ? :zh : :en
	  	mail(:to => email, :subject => I18n.t("contact_us_email_subject"), :bcc => [Rails.application.config.email_list[:leon], Rails.application.config.email_list[:robin]])
	end

	def send_newsletter(recipients)
		@news = Post.latest.news
		@posts = Post.latest.posts
		mail(:bcc => recipients.map(&:email), :subject => "Kicks4Love Newsletter | 鞋侣时事通讯")
	end
end