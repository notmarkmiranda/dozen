class GamePolicy < ApplicationPolicy
  attr_reader :game,
              :user

  def initialize(user, game)
    @user = user
    @game = game
  end

  def destroy?
    user_is_admin?(game.season.league)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def league
    # NOTE: saved for when games can belong directly to seasons and not leagues
    game&.season&.league # || game&.league
  end
end
