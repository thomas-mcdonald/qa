class AddIndexToUserIdOnReputationEvents < ActiveRecord::Migration
  def change
    add_index :reputation_events, :user_id
  end
end
