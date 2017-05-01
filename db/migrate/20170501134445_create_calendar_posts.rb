class CreateCalendarPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :calendar_posts do |t|
      t.string :title_en
      t.string :title_cn
      t.date :release_date
      t.string :image
      t.integer :release_type, :default => 0, :null => false
      t.timestamps
    end
  end
end
