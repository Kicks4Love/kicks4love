class AddTypeToPost < ActiveRecord::Migration[5.0]
  def change
  	add_column :posts, :post_type, :integer, :default => 0, :null => false
  end
end
