class CreateVideos < ActiveRecord::Migration[5.1]
  def change
    create_table :videos do |t|
      t.string :video_url
      t.integer :likes
      t.integer :views
      t.string :duration

      t.timestamps
    end
  end
end
