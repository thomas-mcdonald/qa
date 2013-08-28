class AddLastActiveToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :last_active_user_id, :integer
    add_column :questions, :last_active_at, :datetime
  end
end
