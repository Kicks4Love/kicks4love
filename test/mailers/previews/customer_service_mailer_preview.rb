# Preview all emails at http://localhost:3000/rails/mailers/customer_service_mailer
class CustomerServiceMailerPreview < ActionMailer::Preview
  def newsletter
    news_posts = Post.latest.news
    headline_posts = Post.latest.posts
    CustomerServiceMailer.newsletter(Rails.application.config.email_list[:leon], news_posts, headline_posts)
  end
end