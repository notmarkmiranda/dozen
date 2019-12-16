class LeagueDecorator < ApplicationDecorator
  delegate_all

  def admin_text
    return unless h.current_user
    membership = object.memberships.find_by(user_id: h.current_user.id)
    membership&.admin? ? "Administrator" : "Member"
  end

  def last_completed_game_full_date
    if last_completed_game
      last_completed_game.formatted_full_date
    end
  end

  def last_completed_game_partial
    last_completed_game ? render_last_completed_game : render_no_prior_game
  end

  def last_completed_game_pot_size
    last_completed_game&.pot_text
  end

  def last_completed_game_players_count
    last_completed_game&.player_text
  end

  def last_completed_game_winner
    if last_completed_game
      last_completed_game.decorate.winner_name
    end
  end

  def public_text
    league.public_league ? "Public League" : "Private League"
  end

  private

  def last_completed_game
    league.last_completed_game
  end

  def render_last_completed_game
    h.render partial: 'shared/games/last_completed_game'
  end

  def render_no_prior_game
    h.content_tag :div, 'No prior game results, check back later.'
  end
end
