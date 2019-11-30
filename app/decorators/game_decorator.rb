class GameDecorator < ApplicationDecorator
  delegate_all

  def buy_in_text
    h.number_to_currency(buy_in, precision: 0)
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

  def player_text
    completed? ? "SOMETHING" : estimated_player_text
  end

  def pot_text
    completed? ? "SOMETHING" : estimated_pot_text
  end

  def rebuy_text
    add_ons? ? 'Allows rebuys or add-ons' : 'Does not allow rebuys or add-ons'
  end

  def table_pot_text
    completed? ? 'SOMETHING' : overview_estimated_pot_text
  end

  def table_player_text
    completed? ? 'SOMETHING' : estimated_players_count
  end

  def winner_name
    return 'Not completed' if game.not_completed?
    'Oops'
  end

  private

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
