require "rails_helper"

RSpec.describe CalendarPost, :type => :model do
    it "identifies posts created more than a month ago as old posts" do
      create(:calendar_post)
      old_post = create(:calendar_post, release_date: 31.days.ago)

      expect(CalendarPost.old.ids).to match_array([old_post.id])
    end
end
