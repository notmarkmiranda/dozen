class SeasonDecorator < ApplicationDecorator
  delegate_all

  def complete_or_uncomplete_buttons
    season.completed ? uncomplete_button : complete_button
  end

  private

  def complete_button
    h.button_to 'Complete Season', h.season_complete_path(season), class: 'btn btn-outline-secondary'
  end

  def uncomplete_button
    h.button_to 'Uncomplete and Activate Season', h.season_uncomplete_path(season), class: 'btn btn-outline-secondary'
  end
end
