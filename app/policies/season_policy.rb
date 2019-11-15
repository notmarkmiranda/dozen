class SeasonPolicy < ApplicationPolicy
  attr_reader :league,
              :season,
              :user

  def initialize(user, season)
    @user = user
    @season = season
    @league = season.league
  end

  def show?
    return true if league.public_league
    return false unless user
    league.memberships.find_by(user: user)
  end



  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
