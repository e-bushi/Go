class AddDataToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :likes, :integer
    add_column :videos, :views, :integer
    add_column :videos, :duration, :string
  end
end
