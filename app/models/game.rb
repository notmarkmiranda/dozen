class Game < ApplicationRecord
  belongs_to :season, optional: true
  belongs_to :league, optional: true

  def league_name
    season.league.name
  end

  def league_location
    season.league.location
  end
end
