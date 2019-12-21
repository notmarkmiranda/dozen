class LeaguePolicy < ApplicationPolicy
  attr_reader :league, :user

  def initialize(user, league)
    @user = user
    @league = league
  end

  def show?
    return true if league.public_league
    return false unless user
    league.memberships.find_by(user: user)
  end

  def edit?
    user_is_admin?(league)
  end

  def update?
    user_is_admin?(league)
  end

  def destroy?
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
end
