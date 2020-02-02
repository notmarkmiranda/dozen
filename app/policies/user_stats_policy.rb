class UserStatsPolicy < ApplicationPolicy
  def show?
    user_and_object_user_same_league?
  end
  
  class Scope < Scope
    def resolve
      scope.all
    end
  end
  
  private
  
  def user_and_object_user_same_league?
    record_id = record.id || record.user_id

    return false unless user && record
    return true if user.id == record_id
    
    memberships_hash = Membership.where(user_id: [user.id, record_id]).group(:league_id).count
    
    memberships_hash.values.any? { |n| n == 2 }
  end
end
