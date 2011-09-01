class AddDeletedAtColumns < ActiveRecord::Migration
  def self.up
    add_column :answers, :deleted_at, :datetime
    add_column :questions, :deleted_at, :datetime
  end

  def self.down
    remove_column :questions, :deleted_at
    remove_column :answers, :deleted_at
  end
end