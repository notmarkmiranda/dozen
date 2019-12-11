class PlayerPolicy < ApplicationPolicy
  def initialize(user, player)
    @user = user
    @player = player
  end

  def create?
    user_is_admin?(@player.game.season_league)
  end

  def update?
    user_is_admin?(@player.game.season_league)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
