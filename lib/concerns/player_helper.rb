module PlayerHelper
  def find_finishing_order
    players_except_self = game.players_except_self(player)
    if players_except_self.empty?
      player.finishing_order = 1
    else
      order = players_except_self.maximum(:finishing_order) + 1
      player.finishing_order = order
    end
  end
end
