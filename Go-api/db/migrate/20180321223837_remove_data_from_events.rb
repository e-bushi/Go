class RemoveDataFromEvents < ActiveRecord::Migration[5.1]
  def change
    remove_column :events, :location, :string
    remove_column :events, :attendees, :string
  end
end
