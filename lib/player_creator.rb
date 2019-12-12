require './lib/concerns/player_helper'

class PlayerCreator
  include ::PlayerHelper

  attr_accessor :commit,
                :current_user,
                :errors,
                :game,
                :params,
                :player

  def initialize(params, commit, current_user)
    @params = params
    @player = nil
    @game = nil
    @errors = []
    @commit = commit.parameterize.underscore.to_sym
    @current_user = current_user
  end

  def save
    @player  = Player.new(params)
    @game = @player.game
    PlayerPolicy.new(current_user, @player).create?
    if commit == :finish_player
      add_finished_time_to_params
      find_finishing_order
    elsif commit == :add_rebuy_or_add_on_only
      # TODO: What do we do here?
    end

    if @player.save
      self.player = @player
      return true
    else
      self.errors = @player.errors.full_messages
      return false
    end
  end

  def add_finished_time_to_params
    params.merge!(finished_at: DateTime.now.utc)
  end
end
