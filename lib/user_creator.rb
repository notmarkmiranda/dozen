class UserCreator
  #attr_accessor :user
  attr_reader :game,
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
    else
       
    end
  end

  private

  def create_membership
    user.memberships.create!(role: 0, league: game.season_league)
  end
end
