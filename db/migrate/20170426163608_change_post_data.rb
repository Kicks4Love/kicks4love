class ChangePostData < ActiveRecord::Migration[5.0]
  def change
  	remove_column :posts, :content
    rename_column :posts, :title, :title_en
    add_column :posts, :title_cn, :string
  	add_column :posts, :pointer_type, :integer, :default => 0, :null => false
  	add_column :posts, :pointer_id, :integer
  	rename_column :feature_posts, :title, :title_en
  	rename_column :feature_posts, :image, :main_image
  	rename_column :feature_posts, :content, :content_en
  	add_column :feature_posts, :title_cn, :string
  	add_column :feature_posts, :cover_image, :string
  	add_column :feature_posts, :content_cn, :text
  	remove_column :calendar_posts, :color
  	rename_column :calendar_posts, :event_name, :event_name_en
  	add_column :calendar_posts, :event_name_cn, :string
  	rename_column :trend_posts, :title, :title_en
  	rename_column :trend_posts, :image, :main_image
  	rename_column :trend_posts, :content, :content_en
  	add_column :trend_posts, :title_cn, :string
  	add_column :trend_posts, :cover_image, :string
  	add_column :trend_posts, :content_cn, :text
  end
end
