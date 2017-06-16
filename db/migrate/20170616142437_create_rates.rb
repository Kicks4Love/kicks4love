class CreateRates < ActiveRecord::Migration[5.0]
  def change
    create_table :rates do |t|
    	t.integer :score 
    	t.integer :post_id
      t.string :post_type
      t.timestamps
    end
  end
end