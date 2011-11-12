class AddDefaultsToCounters < ActiveRecord::Migration
  def change
    change_column_default :questions, :answers_count, 0
  end
end
