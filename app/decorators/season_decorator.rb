class SeasonDecorator < ApplicationDecorator
  delegate_all

  def active_class
    season.count_in_standings? ? 'active' : 'inactive'
  end

  def complete_or_uncomplete_buttons
    season.completed ? uncomplete_button : complete_button
  end

  def inactive_class
    !season.count_in_standings? ? 'active' : 'inactive'
  end

  private

  def complete_button
    h.button_to 'Complete Season', h.season_complete_path(season), class: 'btn btn-outline-secondary mr-2'
  end

  def uncomplete_button
    h.button_to 'Uncomplete and Activate Season', h.season_uncomplete_path(season), class: 'btn btn-outline-secondary mr-2'
  end
end
