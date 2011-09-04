class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.string :token
      t.string :parameters
      t.integer :user_id
      t.boolean :dismissed, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
