class SeasonDecorator < ApplicationDecorator
  include LastGameHelper
  delegate_all

  def active_season_class
    "active-season" if season.active_season?
  end

  def complete_or_uncomplete_buttons
    season.completed ? uncomplete_button : complete_button
  end

  def counted_games_percentage
    setting = settings.find_by(name: 'COUNTED_GAMES_FOR_STANDINGS')
    "#{setting.value}%"
  end

  def counted_class
    season.count_in_standings? ? 'active' : 'inactive'
  end

  def scoring_by_points
    season.scoring_system == 0 ? 'active' : 'inactive'
  end

  def scoring_by_net_earnings
    season.scoring_system == 1 ? 'active' : 'inactive'
  end

  def end_date
    games = season.games.in_date_order
    return 'Still in Progress' if games.any? && season.not_completed?
    return 'N/A' if games.empty?
    date_and_year(games.last.date)
  end

  def leader_full_name(current_user=nil)
    season.leader&.user_display_name(current_user)
  end

  def leader_full_score
    score = league.leader&.cumulative_score
    h.number_with_precision(score, precision: 3)
  end

  def league_location
    season.league.location
  end

  def league_name
    season.league.name
  end

  def number_in_order_text
    number = season.number_in_order
    return "#{number}*" if season.active_season
    number
  end

  def start_date
    first_game = season.games.in_date_order&.first
    return date_and_year(first_game.date) if first_game
    "N/A"
  end

  def total_moneys
    h.number_to_currency(season.total_pot, precision: 0)
  end

  def total_season_count
    league.seasons.count
  end

  def uncounted_class
    !season.count_in_standings? ? 'active' : 'inactive'
  end

  private

  def complete_button
    h.button_to 'Complete Season', h.complete_season_path(season), class: 'btn btn-outline-secondary btn-block-xs mr-2'
  end

  def uncomplete_button
    h.button_to 'Uncomplete and Activate Season', h.uncomplete_season_path(season), class: 'btn btn-outline-secondary btn-block-xs mr-2'
  end
end
