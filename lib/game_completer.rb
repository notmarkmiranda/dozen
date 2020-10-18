class GameCompleter
  attr_reader :action,
              :alerts,
              :game,
              :players

  def initialize(game, action)
    @game = game
    @action = action.parameterize.underscore.to_sym
    @players = game.players
    @alerts = []
  end

  def save
    if action == :complete
      return rebuyers_remaining if game.rebuyers.any?
      return no_players if game.finished_players.count < 2
      players.in_place_order.each_with_index do |player, index|
        player.update(finishing_place: index + 1)
        player.calculate_score(game.players.count, game.buy_in)
        player.calculate_payout
      end
      @alerts << 'Game completed.'
      @game.update!(completed: true)
    elsif action == :uncomplete
      players.each do |player|
        player.update(finishing_place: nil, score: nil)
      end
      @alerts << 'Game uncompleted'
      game.update(completed: false)
      game.players.update(payout: 0.0)
    end
  end

  private

  def no_players
    @alerts << 'There are not enough players to finish this game'
  end

  def rebuyers_remaining
    @alerts << 'All players must be finished before completing this game'
  end
end
