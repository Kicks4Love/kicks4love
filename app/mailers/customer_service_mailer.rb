class CustomerServiceMailer < ApplicationMailer
	# options include first_name, last_name, chinese and comment
	def send_contact_email(email, options={})
	  	@contact_information = {:email => email}.merge(options)
	  	I18n.locale = options[:chinese] ? :zh : :en
	  	mail(:to => email, :subject => I18n.t("contact_us_email_subject"), :bcc => [Rails.application.config.email_list[:leon], Rails.application.config.email_list[:robin]])
	end

	def newsletter(email)
		@news = Post.latest.news
		@posts = Post.latest.posts
		subject = @posts.first.title_en + ' | ' + @posts.first.title_cn
		# attachments.inline["nav_logo.png"] = File.read("#{Rails.root}/app/assets/images/nav_logo.png")
		mail(:to => email, :subject => subject)
	end

	def self.send_newsletter(recipients)
		recipients.each do |recipient|
			newsletter(recipient.email).deliver
		end
	end

end
