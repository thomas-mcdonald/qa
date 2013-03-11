class AddPostTypeToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :post_type, :string
  end
end
