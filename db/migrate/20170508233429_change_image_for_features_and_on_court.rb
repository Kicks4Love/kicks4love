class ChangeImageForFeaturesAndOnCourt < ActiveRecord::Migration[5.0]
  def up
    rename_column :feature_posts, :main_image, :main_image_1
    add_column :feature_posts, :main_image_2, :string, :default => ''
    add_column :feature_posts, :main_image_3, :string, :default => ''
    rename_column :on_court_posts, :main_image, :main_image_1
    change_column_default :on_court_posts, :main_image_1, ''
    add_column :on_court_posts, :main_image_2, :string, :default => ''
  end

  def down
    remove_column :on_court_posts, :main_image_2
    change_column_default :on_court_posts, :main_image_1, nil
    rename_column :on_court_posts, :main_image_1, :main_image
    remove_column :feature_posts, :main_image_3
    remove_column :feature_posts, :main_image_2
    rename_column :feature_posts, :main_image_1, :main_image
  end
end
