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
  
  def destroy?
    league.memberships.find_by(user: user)&.admin?
  end
  
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
