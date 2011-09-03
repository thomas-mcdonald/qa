class AddIndexToVoteable < ActiveRecord::Migration
  def self.up
    add_index :votes, [:voteable_type, :voteable_id]
  end

  def self.down
    remove_index :votes, [:voteable_type, :voteable_id]
  end
end