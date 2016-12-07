class AddMoreStuffToOnCourt < ActiveRecord::Migration[5.0]
  def up
    rename_column :on_court_posts, :title, :title_en
    rename_column :on_court_posts, :image, :cover_image
    rename_column :on_court_posts, :content, :content_en
    add_column :on_court_posts, :title_cn, :string
    add_column :on_court_posts, :main_image, :string
    add_column :on_court_posts, :content_cn, :text

  end

  def down
    rename_column :on_court_posts, :title_en, :title
    rename_column :on_court_posts, :cover_image, :image
    rename_column :on_court_posts, :content_en, :content
    remove_column :on_court_posts, :title_cn, :string
    remove_column :on_court_posts, :main_image, :string
    remove_column :on_court_posts, :content_cn, :text

  end
end
