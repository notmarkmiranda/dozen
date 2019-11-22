class Game < ApplicationRecord
  validates :buy_in, presence: true
  belongs_to :season, optional: true
  belongs_to :league, optional: true

  delegate :league, to: :season, prefix: true

  def league_name
    season.league.name
  end

  def league_location
    season.league.location
  end
end
