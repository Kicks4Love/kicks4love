class CreateFeaturePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :feature_posts do |t|
    	t.string :title
    	t.text :content
    	t.string :image

      	t.timestamps
    end
  end
end
