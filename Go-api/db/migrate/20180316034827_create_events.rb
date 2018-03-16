class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :organizer
      t.string :attendees
      t.integer :wants
      t.string :location
      t.boolean :private
      t.boolean :public

      t.timestamps
    end
  end
end
