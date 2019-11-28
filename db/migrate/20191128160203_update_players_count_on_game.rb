class UpdatePlayersCountOnGame < ActiveRecord::Migration[6.0]
  def up
    rename_column :games, :players_count, :estimated_players_count
  end

  def down
    rename_column :games, :estimated_players_count, :players_count
  end
end
