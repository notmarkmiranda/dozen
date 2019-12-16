class LeagueDecorator < ApplicationDecorator
  include LastGameHelper
  delegate_all

  def admin_text
    return unless h.current_user
    membership = object.memberships.find_by(user_id: h.current_user.id)
    membership&.admin? ? "Administrator" : "Member"
  end

  def public_text
    league.public_league ? "Public League" : "Private League"
  end
end
