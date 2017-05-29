class CreateRumorPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :rumor_posts do |t|

      t.timestamps
    end
  end
end
