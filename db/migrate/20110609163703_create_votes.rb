class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :value
      t.integer :voteable_id
      t.string :voteable_type
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
