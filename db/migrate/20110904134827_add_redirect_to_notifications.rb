class AddRedirectToNotifications < ActiveRecord::Migration
  def self.up
    add_column :notifications, :redirect_type, :string
    add_column :notifications, :redirect_id, :integer
  end

  def self.down
    remove_column :notifications, :redirect_id
    remove_column :notifications, :redirect_type
  end
end
