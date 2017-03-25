class AddDataToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :gid, :string
    add_column :games, :state, :string
  end
end
