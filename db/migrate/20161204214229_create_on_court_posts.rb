class CreateOnCourtPosts < ActiveRecord::Migration[5.0]
  def up
    create_table :on_court_posts do |t|
      t.string :title
      t.text :content
      t.string :image
      t.timestamps
    end
  end

  def down
    drop_table :on_court_posts
  end
end
