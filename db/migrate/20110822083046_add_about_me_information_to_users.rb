class AddAboutMeInformationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :about_me, :text
    add_column :users, :twitter, :string
  end

  def self.down
    remove_column :users, :twitter
    remove_column :users, :about_me
  end
end
