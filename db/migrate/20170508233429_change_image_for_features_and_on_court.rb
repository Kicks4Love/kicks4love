class ChangeImageForFeaturesAndOnCourt < ActiveRecord::Migration[5.0]

    def up
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
