class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.references :user, index: true
      t.integer :subject_id
      t.integer :subject_type
      t.string :name

      t.timestamps
    end
  end
end
