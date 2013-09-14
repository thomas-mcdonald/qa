class CreateReputationEvents < ActiveRecord::Migration
  def change
    create_table :reputation_events do |t|
      t.integer :user_id
      t.integer :event_type
      t.string :action_type
      t.integer :action_id

      t.timestamps
    end
  end
end
