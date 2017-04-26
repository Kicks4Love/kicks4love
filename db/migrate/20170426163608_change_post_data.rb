class ChangePostData < ActiveRecord::Migration[5.0]
  def change
  	remove_column :posts, :content
  	add_column :posts, :pointer_type, :integer, :default => 0, :null => false
  	add_column :posts, :pointer_id, :integer
  end
end
