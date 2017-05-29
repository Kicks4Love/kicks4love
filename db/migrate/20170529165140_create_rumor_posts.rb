class CreateRumorPosts < ActiveRecord::Migration[5.0]
  def up
    create_table :rumor_posts do |t|
    	t.string :title_en
    	t.string :title_cn
      	t.text :content_en
      	t.text :content_cn
      	t.string :main_images
      	t.string :cover_image
      	t.timestamps
    end
  end

  def down
    drop_table :rumor_posts
  end
end
