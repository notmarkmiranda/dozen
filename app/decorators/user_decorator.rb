class UserDecorator < ApplicationDecorator
  delegate_all

  def administrator_and_member_count_text
    league_count = league_count_by_role
    admin_leagues = h.pluralize(league_count[:admin], 'league')
    member_leagues = h.pluralize(league_count[:member], 'league')
    output = h.content_tag :div, "Administrator of #{admin_leagues}", class: 'admin-text text-muted'
    output += h.content_tag :div, "Member of #{member_leagues}", class: 'member-text text-muted'

    h.content_tag :div, output, class: 'membership-text'
  end

  def attendance_text
    output = h.content_tag :strong, "Attendance: "
    text = "#{seasons_games_count[:played]} out of #{h.pluralize(seasons_games_count[:total], 'game')}"
    output += text
    percentage = " - #{h.number_with_precision(seasons_games_count[:percentage], precision: 1)}%"
    output += percentage
  end

  def display_name(current_user=nil)
    return short_name if current_user.nil?
    UserStatsPolicy.new(current_user, object).show? ? full_name : short_name
  end

  def full_name_or_email
    object.first_name ? full_name : object.email
  end

  def full_name
    return object.email if object.first_name.blank?
    "#{object.first_name} #{object.last_name}".strip
  end

  def games_played_text
    output = h.content_tag :strong, "Games Played: "
    games_played_count = games_played.count
    output += games_played_count.to_s
    output
  end

  def games_won_text
    output = h.content_tag :strong, "Games Won: "
    text = "#{games_won_played_count[:won]} out of #{h.pluralize(games_won_played_count[:played], 'game')}"
    output += text
    percentage = " - #{h.number_with_precision(games_won_played_count[:percentage], precision: 1)}%"
    output += percentage
    output
  end

  def last_initial
    object.last_name[0]
  end

  def short_name
    return object.email if object.first_name.blank?
    "#{object.first_name} #{last_initial}".strip
  end
end
