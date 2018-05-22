require "rails_helper"

RSpec.describe AdminUser, :type => :model do
  context "with root as email prefix" do
    it "identifies as root admin_user" do
      user = create(:root_admin_user)
      
      expect(user.root_user?).to be true
      expect(AdminUser.root_user.id).to eq(user.id)
    end
  end

  context "with generic email address" do
    it "does not identify as root admin_user" do
      user = create(:admin_user)

      expect(user.root_user?).to be false
      expect(AdminUser.non_root_users.ids).to match_array([user.id])
    end
  end

  context "when root user has already been set" do
    before do
      create(:root_admin_user)
    end

    it "does not allow creating new users with root prefix email" do
      expect { create(:root_admin_user) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
