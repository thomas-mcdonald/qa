class AddIndexesToTaggings < ActiveRecord::Migration
  def self.up
    add_index :taggings, :tag_id
    add_index :taggings, :question_id
  end

  def self.down
    remove_index :taggings, :question_id
    remove_index :taggings, :tag_id
    mind
  end
end