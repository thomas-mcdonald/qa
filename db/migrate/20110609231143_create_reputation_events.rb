class CreateReputationEvents < ActiveRecord::Migration
  def self.up
    create_table :reputation_events do |t|
      t.integer :value
      t.string :reputable_type
      t.integer :reputable_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :reputation_events
  end
end
