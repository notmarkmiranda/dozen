require './lib/concerns/player_helper'

class PlayerUpdater
  include PlayerHelper

  attr_accessor :commit,
                :errors,
                :game,
                :player

  def initialize(player, commit)
    @player = player
    @game = player.game
    @errors = []
    @commit = commit.parameterize.underscore.to_sym
  end

  def save
    if commit == :additional_to_finished
      find_finishing_order
      player.save
    elsif commit == :move_up
      current_player_place = player.finishing_order
      swap_player_place = current_player_place + 1
      swap_player = game.players.find_by(finishing_order: swap_player_place)

      swap_player.finishing_order = current_player_place
      player.finishing_order = swap_player_place
      [swap_player, player].each(&:save)
    end
  end
end
