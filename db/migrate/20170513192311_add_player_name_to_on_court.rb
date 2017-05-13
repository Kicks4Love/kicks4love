class AddPlayerNameToOnCourt < ActiveRecord::Migration[5.0]
  def change
  	add_column :on_court_posts, :player_name_en, :string
    add_column :on_court_posts, :player_name_cn, :string
  end
end
