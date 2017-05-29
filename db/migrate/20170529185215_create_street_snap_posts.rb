class CreateStreetSnapPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :street_snap_posts do |t|
      t.string :title_en
      t.string :title_cn
      t.string :cover_image
      t.string :main_images
      t.text   :content_en
      t.text   :content_cn
      t.text   :post_composition
      t.references :author, foreign_key: {to_table: :admin_users}
      t.timestamps
    end
  end
end
