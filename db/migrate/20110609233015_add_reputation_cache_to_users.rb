class AddReputationCacheToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :reputation_cache, :integer
  end

  def self.down
    remove_column :users, :reputation_cache
  end
end
