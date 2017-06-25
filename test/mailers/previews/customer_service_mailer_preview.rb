# Preview all emails at http://localhost:3000/rails/mailers/customer_service_mailer
class CustomerServiceMailerPreview < ActionMailer::Preview
  def send_newsletter
    @news = Post.latest.news
    @posts = Post.latest.posts
    CustomerServiceMailer.send_newsletter(Subscriber.all)
  end
end