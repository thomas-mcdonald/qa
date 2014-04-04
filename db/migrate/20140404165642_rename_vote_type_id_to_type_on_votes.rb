class RenameVoteTypeIdToTypeOnVotes < ActiveRecord::Migration
  def change
    rename_column :votes, :vote_type_id, :vote_type
  end
end
