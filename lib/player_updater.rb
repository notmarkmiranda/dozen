require './lib/concerns/player_helper'

class PlayerUpdater
  include PlayerHelper

  FLASH_ALERTS = {
    additional_to_finished: 'Player added to final standings',
    move_up: 'Player moved',
    move_down: 'Player moved',
    delete_player: 'Player deleted',
    move_to_rebuyers: 'Player moved back to rebuyers',
    update_player: 'Player updated'
  }

  attr_accessor :commit,
                :current_user,
                :errors,
                :flash_alert,
                :game,
                :params,
                :player

  def initialize(current_user, player, commit, params=nil)
    @current_user = current_user
    @player = player
    @params = params
    @game = player.game
    @errors = []
    @commit = commit.parameterize.underscore.to_sym
    @flash_alert = nil
  end

  def save
    PlayerPolicy.new(current_user, @player).update?
    @flash_alert = FLASH_ALERTS[commit]
    if commit == :additional_to_finished
      find_finishing_order
      player.save
    elsif commit == :move_up || commit == :move_down
      current_player_index = game.finished_players.index(player)
      swap_player_index = other_player_index(commit, current_player_index)
      swap_player = game.finished_players[swap_player_index]
      current_player_order = player.finishing_order
      swap_player_order = swap_player.finishing_order

      player.finishing_order = swap_player_order
      swap_player.finishing_order = current_player_order
      [swap_player, player].each(&:save)
    elsif commit == :delete_player
      player.destroy
    elsif commit == :move_to_rebuyers
      player.finishing_order, player.finishing_place = nil
      player.save
    elsif commit == :update_player
      player.update(params) 
    end
  end

  def other_player_index(commit, index)
    return index - 1 if commit == :move_up
    index + 1
  end
end
