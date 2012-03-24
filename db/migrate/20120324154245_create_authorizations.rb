class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.integer :user_id
      t.string :provider
      t.text :uid
      t.string :email

      t.timestamps
    end
  end
end
