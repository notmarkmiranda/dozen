module PlayerHelper
  def find_finishing_order
    # players_except_self = game.players_except_self(player)
    if players_except_self(player).empty?
      player.finishing_order = 1
    else
      order = max_finishing_order + 1
      player.finishing_order = order
    end
  end

  def max_finishing_order
    players_except_self(player).maximum(:finishing_order) || 0
  end

  def players_except_self(player)
    @players ||= game.players_except_self(player)
  end
end
