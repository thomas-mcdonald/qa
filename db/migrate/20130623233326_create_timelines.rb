class CreateTimelines < ActiveRecord::Migration
  def change
    create_table :timeline_events do |t|
      t.integer :post_id
      t.string :post_type
      t.integer :action

      t.timestamps
    end

    create_table :timeline_actors do |t|
      t.references :timeline_event, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
