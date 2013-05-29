class AddIndexToVotesOnPost < ActiveRecord::Migration
  def change
    add_index :votes, [:post_type, :post_id]
  end
end
