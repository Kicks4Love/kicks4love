class ChangeImageForFeaturesAndOnCourt < ActiveRecord::Migration[5.0]
  def up
    # rename_column :feature_posts, :main_image, :main_image_1
    # add_column :feature_posts, :main_image_2, :string, :default => ''
    # add_column :feature_posts, :main_image_3, :string, :default => ''
    # rename_column :on_court_posts, :main_image, :main_image_1
    # change_column_default :on_court_posts, :main_image_1, ''
    # add_column :on_court_posts, :main_image_2, :string, :default => ''
    remove_column :feature_posts, :main_image
    add_column :feature_posts, :main_images, :json
    remove_column :on_court_posts, :main_image
    add_column :on_court_posts, :main_images, :json
    remove_column :trend_posts, :main_image
    add_column :trend_posts, :main_images, :json
  end

  def down
    remove_column :on_court_posts, :main_images
    add_column :on_court_posts, :main_image, :string
    remove_column :feature_posts, :main_images
    add_column :feature_posts, :main_image, :string
    remove_column :trend_posts, :main_images
    add_column :trend_posts, :main_images, :string
  end
end
