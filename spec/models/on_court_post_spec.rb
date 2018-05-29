require "rails_helper"

RSpec.describe OnCourtPost, :type => :model do
  let(:author) { create(:admin_user, email: 'zuowei@k4l.com') }

  it "identifies posts created more than 3 month ago as old posts" do
    create(:on_court_post, author: author)
    old_post = create(:on_court_post, created_at: 4.months.ago, author: author)

    expect(OnCourtPost.old.ids).to match_array([old_post.id])
  end

  it "identifies posts with content and images to be has_link" do
    post_with_link = create(:on_court_post_with_link, author: author)
    post = create(:on_court_post, author: author)

    expect(post_with_link.has_link).to be true
    expect(post.has_link).to be false
  end
end