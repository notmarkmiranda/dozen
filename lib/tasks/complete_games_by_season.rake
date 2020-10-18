desc "complete games by season"

task complete_games_by_season: :environment do
  puts "You must include a season_id" unless ENV["season_id"]
  next unless ENV['season_id']
  season = Season.find(ENV['season_id'])
  
  season.games.completed.each do |game|
    ::GameCompleter.new(game, "complete").save
    puts "updated game #{game.id}"
  end
end