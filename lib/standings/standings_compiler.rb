class Standings::StandingsCompiler
  attr_reader :object

  def initialize(object)
    @object = object
  end

  def self.standings(object)
    self.new(object).standings
  end

  def standings
    if object.class == Season
      @active_season_games_count = [object.games_count, 9].min
      @season_users = object.players.pluck(:user_id).uniq
      return if @season_users.empty?

      players = Player.find_by_sql(query)
      ordered_players = PlayerDecorator.decorate_collection(players)
    end
  end

  private

  def query
    # TODO: (2018-04-26) markmiranda => LIMIT 9 needs to change to a season setting
    "SELECT user_id, SUM(score) AS cumulative_score, \
     COUNT(game_id) AS games_count FROM (#{subquery}) AS c_players GROUP BY \
     c_players.user_id ORDER BY cumulative_score DESC"
  end

  def subquery
     # TODO: (2018-04-26) markmiranda => LIMIT 9 needs to change to a season setting
     @season_users.map do |user_id|
      "(SELECT players.* FROM players INNER JOIN games ON \
       players.game_id = games.id WHERE user_id = '#{user_id}' AND \
       games.season_id = '#{object.id}' \
       ORDER BY score DESC LIMIT #{@active_season_games_count})"
    end.join("\nUNION ALL\n")
  end
end