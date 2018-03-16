class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.text :events_attended
      t.string :followers
      t.string :following
      t.string :location

      t.timestamps
    end
  end
end
