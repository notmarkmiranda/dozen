class ChangeDateOnGames < ActiveRecord::Migration[6.0]
  def up
    rename_column :games, :date, :date_and_time
    add_column :games, :date, :date
    Game.find_each do |game|
      game.update!(date: game.date_and_time&.to_date)
    end
    remove_column :games, :date_and_time
  end
end
