class PlayerCreator
  attr_accessor :errors,
                :game,
                :params,
                :player

  def initialize(params)
    @params = params
    @player = nil
    @game = nil
    @errors = []
  end

  def save
    add_finished_time_to_params
    @player  = Player.new(params)
    @game = @player.game
    find_finishing_order
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
    return if game.players.empty?
  end

  def add_finished_time_to_params
    params.merge!(finished_at: DateTime.now.utc)
  end
end
