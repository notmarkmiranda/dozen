class Standings::StandingsCompiler
  attr_reader :object, :limit

  def self.standings(object, limit)
    self.new(object, limit).standings
  end
  
  def initialize(object, limit=nil)
    @object = object
    @limit = limit || 99
  end

  def standings
    players = nil
    if object.class == Season
      if object.points?
        @active_season_games_count = [object.games_count, season_limit].min
        @season_users = object.players.pluck(:user_id).uniq
        return if @season_users.empty?

        players = Player.find_by_sql(query)
      elsif object.net_earnings?
        players = Player.
          joins(:game).
          where("games.season_id = ? AND games.completed = TRUE", object.id).
          uniq { |pl| pl.user_id }.
          sort_by { |pl| -pl.net_earnings_by_season(object) }
          
      end
    elsif object.class == League
      @league_games_count = [object.games_count, 10].min
      @league_users = object.players
        .where('seasons.count_in_standings = ?', true)
        .pluck(:user_id).uniq
      return if @league_users.empty?
      @season_ids = object.seasons.where(count_in_standings: true).pluck(:id)

      players = Player.find_by_sql(league_query)
    end
    PlayerDecorator.decorate_collection(players)
  end

  private

  def season_limit
    percentage = object.settings.find_by(name: 'COUNTED_GAMES_FOR_STANDINGS').value.to_f / 100
    games_count = object.games.completed.count
    limit = (percentage * games_count).to_i
    limit.zero? ? 1 : limit
  end

  def league_query
    # TODO: (2020-01-04) markmiranda => LIMIT 10 needs to change to a league setting
    "SELECT user_id, SUM(score) AS cumulative_score, \
     COUNT(game_id) as games_count FROM (#{league_subquery}) AS c_players GROUP BY \
     c_players.user_id ORDER BY cumulative_score DESC \
     LIMIT #{limit}"
  end

  def league_subquery
    # TODO: (2020-01-04) markmiranda => LIMIT 10 needs to change to a league setting
    @league_users.map do |user_id|
      "(SELECT players.* FROM players INNER JOIN games ON \
       players.game_id = games.id WHERE user_id = '#{user_id}' AND \
       games.season_id IN ('#{@season_ids.join("', '")}') AND \
       games.completed = 'true' \ 
       ORDER BY score DESC LIMIT #{@league_games_count})"
    end.join("\nUNION ALL\n")
  end

  def net_earnings_query
    "SELECT user_id, (SUM(payout) - SUM(games.buy_in)) AS earnings \
    FROM players AS c_players \
    INNER JOIN games ON c_players.game_id = games.id \
    AND games.season_id = '#{object.id}' \
    GROUP BY c_players.user_id ORDER BY earnings DESC"
  end

  def query
    # TODO: (2018-04-26) markmiranda => LIMIT 9 needs to change to a season setting
    "SELECT user_id, SUM(score) AS cumulative_score, \
     COUNT(game_id) AS games_count FROM (#{subquery}) AS c_players GROUP BY \
     c_players.user_id ORDER BY cumulative_score DESC \
     LIMIT #{limit}"
  end

  def subquery
     # TODO: (2018-04-26) markmiranda => LIMIT 9 needs to change to a season setting
     @season_users.map do |user_id|
      "(SELECT players.* FROM players INNER JOIN games ON \
       players.game_id = games.id WHERE user_id = '#{user_id}' AND \
       games.season_id = '#{object.id}' AND \
       games.completed = 'true' \
       ORDER BY score DESC LIMIT #{@active_season_games_count})"
    end.join("\nUNION ALL\n")
  end
end
