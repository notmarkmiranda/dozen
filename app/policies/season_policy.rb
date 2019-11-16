class SeasonPolicy < ApplicationPolicy
  attr_reader :season,
              :user

  def initialize(user, season)
    @user = user
    @season = season
  end

  def show?
    return true if league.public_league
    return false unless user
    league.memberships.find_by(user: user)
  end

  def create?
    user_is_admin?(season)
  end

  def destroy?
    user_is_admin?(league)
  end

  # NON-REST ACTIONS

  def confirm?
    user_is_admin?(league)
  end

  def count?
    user_is_admin?(league)
  end

  def deactivate?
    user_is_admin?(league)
  end

  def leave?
    user_is_admin?(league)
  end

  def complete?
    user_is_admin?(league)
  end

  def uncomplete?
    user_is_admin?(league)
  end

  def uncount?
    user_is_admin?(league)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def league
    season&.league
  end
end
