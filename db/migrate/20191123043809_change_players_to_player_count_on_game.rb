class ChangePlayersToPlayerCountOnGame < ActiveRecord::Migration[6.0]
  def up
    rename_column :games, :players, :players_count
  end

  def down
    rename_column :games, :players_count, :players
  end
end
