class GameDecorator < ApplicationDecorator
  delegate_all

  def buy_in_text
    h.number_to_currency(buy_in, precision: 0)
  end

  def formatted_full_date
    full_date(game.date)
  end
  
  def formatted_short_month_full_date
    short_month_full_date(game.date)
  end

  def incomplete_class
    not_completed? ? 'text-danger' : 'completed-game'
  end

  def league_name
    season.league.name
  end

  def league_location
    season.league.location
  end

  def payout_amount(place)
    return nil if game.payout_schedule.empty? || game.payout_schedule[place].nil?
    amount = game.payout(place)
    h.number_to_currency(amount, precision: 2)
  end

  def player_score(user_id)
    score = players.find_by(user_id: user_id).score
    h.number_with_precision(score, precision: 3)
  end

  def player_text
    completed? ? actual_player_text : estimated_player_text
  end

  def pot_text
    completed? ? actual_pot_text : estimated_pot_text
  end

  def rebuy_text
    add_ons? ? 'Allows rebuys or add-ons' : 'Does not allow rebuys or add-ons'
  end

  def table_pot_text
    completed? ? actual_pot : overview_estimated_pot_text
  end

  def table_player_text
    completed? ? players_count : estimated_players_count
  end

  def winner_name(current_user=nil)
    return 'Not completed' if game.not_completed?
    player = game.players.find_by(finishing_place: 1)
    player.decorate.user_display_name(current_user) if player
  end

  private

  def actual_player_text
    "<b># of Players:</b> #{players_count}".html_safe
  end

  def actual_pot
    h.number_to_currency(game.total_pot, precision: 0)
  end
  
  def actual_pot_text
    "<b>Pot Size:</b> #{actual_pot}".html_safe
  end

  def estimated_player_text
    "<b>Estimated Players:</b> #{estimated_players_count}".html_safe
  end

  def estimated_pot_text
    "<b>Estimated Pot:</b> #{estimated_pot}".html_safe
  end

  def estimated_pot
    count = estimated_players_count || 0
    h.number_to_currency(count * buy_in, precision: 0)
  end

  def overview_estimated_pot_text
    estimated_pot
  end
end
