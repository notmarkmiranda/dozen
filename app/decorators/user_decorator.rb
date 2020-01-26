class UserDecorator < ApplicationDecorator
  delegate_all

  def administrator_and_member_count_text
    league_count = user.league_count_by_role
    admin_leagues = h.pluralize(league_count[:admin], 'league')
    member_leagues = h.pluralize(league_count[:member], 'league')
    output = h.content_tag :div, "Administrator of #{admin_leagues}", class: 'admin-text text-muted'
    output += h.content_tag :div, "Member of #{member_leagues}", class: 'member-text text-muted'
    h.content_tag :div, output, class: 'membership-text'
  end

  def full_name_or_email
    object.first_name ? full_name : object.email
  end

  def full_name
    return object.email if object.first_name.blank?
    "#{object.first_name} #{object.last_name}".strip
  end
end
