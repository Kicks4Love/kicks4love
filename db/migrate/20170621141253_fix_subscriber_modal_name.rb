class FixSubscriberModalName < ActiveRecord::Migration[5.0]
  def change
    rename_table :subsribers, :subscribers
  end
end