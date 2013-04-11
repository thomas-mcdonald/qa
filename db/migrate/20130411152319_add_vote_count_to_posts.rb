class AddVoteCountToPosts < ActiveRecord::Migration
  def change
    add_column :answers, :vote_count, :integer, default: 0, null: false
    add_column :questions, :vote_count, :integer, default: 0, null: false
  end
end
