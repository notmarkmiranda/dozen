class PlayerDecorator < ApplicationDecorator
  delegate_all

  def order_in_place(index=nil, total_players)
    return player.finishing_place if game.completed?
    return "Last" if index.zero? && total_players == 1
    return "Last" if (index + 1) == total_players
    return "First" if index.zero?
  end

  private

  def game
    player.game
  end
end
