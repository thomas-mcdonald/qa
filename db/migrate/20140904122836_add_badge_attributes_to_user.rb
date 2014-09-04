class AddBadgeAttributesToUser < ActiveRecord::Migration
  def change
    add_column :users, :bronze_count, :integer, default: 0, null: false
    add_column :users, :silver_count, :integer, default: 0, null: false
    add_column :users, :gold_count, :integer, default: 0, null: false
  end
end
