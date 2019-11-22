class GameDecorator < ApplicationDecorator
  delegate_all

  def buy_in_text
    h.number_to_currency(buy_in, precision: 0)
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

  private

  def estimated_player_text
    "<b>Estimated Players:</b> #{players}".html_safe
  end

  def estimated_pot_text
    "<b>Estimated Pot:</b> #{estimated_pot}".html_safe
  end

  def estimated_pot
    h.number_to_currency(players * buy_in, precision: 0)
  end
end
