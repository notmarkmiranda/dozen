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
    end
  end
end
