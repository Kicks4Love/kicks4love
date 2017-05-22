class AddPostsToAdminUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :feature_posts, :author, foreign_key: {to_table: :admin_users}
    add_reference :on_court_posts, :author, foreign_key: {to_table: :admin_users}
    add_reference :trend_posts, :author, foreign_key: {to_table: :admin_users}
  end
end
