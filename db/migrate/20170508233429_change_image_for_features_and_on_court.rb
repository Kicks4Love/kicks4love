class ChangeImageForFeaturesAndOnCourt < ActiveRecord::Migration[5.0]

    def up
        rename_column :feature_posts, :main_image, :main_images
        rename_column :on_court_posts, :main_image, :main_images
        rename_column :trend_posts, :main_image, :main_images
        add_column :feature_posts, :post_composition, :text
    end

    def down
        remove_column :feature_posts, :post_composition
        rename_column :feature_posts, :main_images, :main_image
        rename_column :on_court_posts, :main_images, :main_image
        rename_column :trend_posts, :main_images, :main_image
    end

end
