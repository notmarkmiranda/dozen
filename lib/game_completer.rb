class GameCompleter
  attr_reader :alerts,
              :game,
              :players

  def initialize(game)
    @game = game
    @players = game.players
    @alerts = []
  end

  def save
    return rebuyers_remaining if game.rebuyers.any?
    return no_players if game.players.count < 2
    players.in_place_order.each_with_index do |player, index|
      player.update(finishing_place: index + 1)
      player.calculate_score(game.players.count, game.buy_in)
    end
    @game.update!(completed: true)
  end

  private

  def no_players
    @alerts << 'There are not enough players to finish this game'
  end

  def rebuyers_remaining
    @alerts << 'All players must be finished before completing this game'
  end
end
