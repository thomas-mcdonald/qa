class AddDismissedToFlags < ActiveRecord::Migration
  def change
    add_column :flags, :dismissed, :boolean, :default => false
  end
end
