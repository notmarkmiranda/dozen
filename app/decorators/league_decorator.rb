class LeagueDecorator < ApplicationDecorator
  delegate_all

  def admin_text
    return unless h.current_user
    membership = object.memberships.find_by(user_id: h.current_user.id)
    membership&.admin? ? "Administrator" : "Member"
  end

  def last_completed_game_full_date
    last_completed_game = league.last_completed_game
    if last_completed_game
      last_completed_game.xfull_date
    end
  end

  def last_completed_game_pot_size
    last_completed_game = league.last_completed_game
    last_completed_game&.pot_text
  end

  def last_completed_game_players_count
    last_completed_game = league.last_completed_game
    last_completed_game&.player_text
  end

  def last_completed_game_winner
    last_completed_game = league.last_completed_game
    if last_completed_game
      last_completed_game.decorate.winner_name
    end
  end
  
  def public_text
    object.public_league ? "Public League" : "Private League"
  end
end
