class AddLastActiveTrackingToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :last_active_user_id, :integer
    add_column :answers, :last_active_at, :datetime
  end
end
