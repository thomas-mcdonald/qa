class AddTagListToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :tag_list, :string
  end

  def self.down
    remove_column :questions, :tag_list
  end
end
