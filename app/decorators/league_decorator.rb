class LeagueDecorator < ApplicationDecorator
  include LastGameHelper
  delegate_all

  def admin_text
    return unless h.current_user
    membership = object.memberships.find_by(user_id: h.current_user.id)
    membership&.admin? ? "Administrator" : "Member"
  end

  def average_pot
    avg_pot = object.completed_games_count.zero? ? 0 : object.average_pot_calculated
    h.number_to_currency(avg_pot, precision: 0)
  end

  def first_game_date
    game = league.first_game
    game ? date_and_year(game.date) : "N / A"
  end
  
  def leader_full_name
    league.leader&.user_full_name
  end

  def leader_full_score
    score = league.leader&.cumulative_score
    h.number_with_precision(score, precision: 3)
  end

  def next_scheduled_game_date
    league.next_scheduled_game ? league.next_scheduled_game.formatted_full_date : 'Not scheduled'
  end

  def public_text
    league.public_league ? "Public League" : "Private League"
  end

  def total_moneys
    h.number_to_currency(league.total_pot, precision: 0)
  end
end
