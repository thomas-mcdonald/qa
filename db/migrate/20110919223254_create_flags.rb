class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.string :flaggable_type
      t.integer :flaggable_id
      t.integer :user_id
      t.string :reason

      t.timestamps
    end
  end
end
