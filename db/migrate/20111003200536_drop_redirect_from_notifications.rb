class DropRedirectFromNotifications < ActiveRecord::Migration
  def up
    remove_column :notifications, :redirect_type
    remove_column :notifications, :redirect_id
  end

  def down
    add_column :notifications, :redirect_type, :string
    add_column :notifications, :redirect_id, :integer
  end
end
