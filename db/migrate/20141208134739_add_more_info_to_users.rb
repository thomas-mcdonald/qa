class AddMoreInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :location, :string, default: '', null: false
    add_column :users, :website, :string, default: '', null: false
  end
end
