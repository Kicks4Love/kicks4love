# Preview all emails at http://localhost:3000/rails/mailers/customer_service_mailer
class CustomerServiceMailerPreview < ActionMailer::Preview

  def newsletter
    CustomerServiceMailer.newsletter(Subscriber.all)
  end
  
end