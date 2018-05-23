require "rails_helper"

RSpec.describe FeaturePost, :type => :model do
    let(:author) { create(:admin_user, email: 'robin@k4l.com') }
    it "identifies posts created more than 3 month ago as old posts" do
      create(:feature_post, author: author)
      old_post = create(:feature_post, author: author, created_at: 4.months.ago)

      expect(FeaturePost.old.ids).to match_array([old_post.id])
    end
end

RSpec.describe RumorPost, :type => :model do
    let(:author) { create(:admin_user, email: 'jackie@k4l.com') }
    it "identifies posts created more than 3 month ago as old posts" do
      create(:rumor_post, author: author)
      old_post = create(:rumor_post, author: author, created_at: 4.months.ago)

      expect(RumorPost.old.ids).to match_array([old_post.id])
    end
end

RSpec.describe StreetSnapPost, :type => :model do
    let(:author) { create(:admin_user, email: 'leon@k4l.com') }
    it "identifies posts created more than 3 month ago as old posts" do
      create(:street_snap_post, author: author)
      old_post = create(:street_snap_post, author: author, created_at: 4.months.ago)

      expect(StreetSnapPost.old.ids).to match_array([old_post.id])
    end
end

RSpec.describe TrendPost, :type => :model do
    let(:author) { create(:admin_user, email: 'robin@k4l.com') }
    it "identifies posts created more than 3 month ago as old posts" do
      create(:trend_post, author: author)
      old_post = create(:trend_post, author: author, created_at: 4.months.ago)

      expect(TrendPost.old.ids).to match_array([old_post.id])
    end
end