class GamePolicy < ApplicationPolicy
  attr_reader :game,
              :user

  def initialize(user, game)
    @user = user
    @game = game
  end

  def show?
    return true if league.public_league?
    return false unless user
    league.memberships.find_by(user: user)
  end

  def new?
    user_is_admin?(league)
  end

  def create?
    user_is_admin?(league)
  end

  def edit?
    user_is_admin?(league) && game.not_completed?
  end

  def update?
    user_is_admin?(league)
  end

  def destroy?
    user_is_admin?(league)
  end

  def complete?
    user_is_admin?(league)
  end

  def uncomplete?
    user_is_admin?(league)
  end
  
  def create_user?
    user_is_admin?(league)
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
