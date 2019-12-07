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
    # TODO
    # score all the players
    players.in_place_order.each_with_index do |player, index|
      player.update(finishing_place: index + 1)
      player.calculate_score(game.players.count, game.buy_in)
    end
    # complete the game
    @game.update!(completed: true)
  end
end
