class RemoveDataFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column(:users, :followers)
    remove_column(:users, :following)
  end
end
