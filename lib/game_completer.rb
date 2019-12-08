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
    return early_redirect if game.rebuyers.any?
    players.in_place_order.each_with_index do |player, index|
      player.update(finishing_place: index + 1)
      player.calculate_score(game.players.count, game.buy_in)
    end
    @game.update!(completed: true)
  end

  private

  def early_redirect
    @alerts << 'All players must be finished before completing this game'
  end
end
