class CreateSubsribers < ActiveRecord::Migration[5.0]

  	def change
    	create_table :subsribers do |t|
      		t.string :email

      		t.timestamps
    	end
  	end
end
