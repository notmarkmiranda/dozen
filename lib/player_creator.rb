class PlayerCreator
  attr_accessor :commit,
                :errors,
                :game,
                :params,
                :player

  def initialize(params, commit)
    @params = params
    @player = nil
    @game = nil
    @errors = []
    @commit = commit.parameterize.underscore.to_sym
  end

  def save
    # THIS IS WHERE YOU STOPPED
    # NEED TO SPLIT ON COMMIT TYPE SWITCH CASE? OR EXTRACT OT IT'S OWN LIB / CLASS?
    @player  = Player.new(params)
    @game = @player.game

    if commit == :finish_player
      add_finished_time_to_params
      find_finishing_order
    elsif commit == :add_rebuy_or_add_on_only
    end

    if @player.save
      self.player = @player
      return true
    else
      self.errors = @player.errors.full_messages
      return false
    end
  end

  private

  def find_finishing_order
    if @game.players.empty?
      player.finishing_order = 1
    else
    end
  end

  def add_finished_time_to_params
    params.merge!(finished_at: DateTime.now.utc)
  end
end
