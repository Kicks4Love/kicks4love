# Preview all emails at http://localhost:3000/rails/mailers/customer_service_mailer
class CustomerServiceMailerPreview < ActionMailer::Preview
  def newsletter
    all_subs = Subscriber.all
    CustomerServiceMailer.newsletter(Rails.application.config.email_list[:leon])
  end
end