class PlayerUpdater
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

  private

  def find_finishing_order
    if game.players_except_self(player).empty?
      player.finishing_order = 1
    end
  end
end
