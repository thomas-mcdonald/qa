class CreatePostHistories < ActiveRecord::Migration
  def change
    create_table :post_histories do |t|
      t.string :title
      t.string :body
      t.string :tag_list
      t.references :timeline_event, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
