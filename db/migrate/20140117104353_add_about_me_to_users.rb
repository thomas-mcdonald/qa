class AddAboutMeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :about_me, :text, default: "", null: false
  end
end
