class UserCreator
  attr_reader :alerts,
              :game,
              :user,
              :user_params

  def initialize(user_params, game)
    @game = game
    @user_params = user_params
    @user = nil
    @alerts = []
  end

  def save
    new_user = User.new(user_params)
    new_user.password = SecureRandom.hex(8)
    if new_user.save
      @user = new_user 
      create_membership
      @alerts << "New user created for #{new_user.decorate.full_name}"
      return true
    else
      @alerts << new_user.errors.full_messages
      return false
    end
  end

  private

  def create_membership
    user.memberships.create!(role: 0, league: game.season_league)
  end
end
