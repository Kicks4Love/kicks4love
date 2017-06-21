# Preview all emails at http://localhost:3000/rails/mailers/customer_service_mailer
class CustomerServiceMailerPreview < ActionMailer::Preview
  def newsletter
    all_subs = Subsriber.all
    CustomerServiceMailer.newsletter("danielzhou@kicks4love.com")
  end
end
