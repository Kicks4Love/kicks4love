class ApplicationMailer < ActionMailer::Base

  default from: 'customerservice@kicks4love.com'
  
  # options include first_name, last_name, chinese and comment
  def send_contact_email(email, options={})
  	@contact_information = {:email => email}.merge(options)
  	mail(:to => email, :subject => I18n.t("contact_us_email_subject"))
  end

end
