class AddLastUpdatedAtToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :last_activity_at, :datetime
    add_column :questions, :last_active_user_id, :integer
  end

  def self.down
    remove_column :questions, :last_active_user_id
    remove_column :questions, :last_activity_at
  end
end
