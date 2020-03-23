class Setting < ApplicationRecord
  belongs_to :settable, polymorphic: true

  ALL_SETTINGS = {
    league: [],
    season: [
      {
        name: 'COUNTED_GAMES_FOR_STANDINGS',
        value: '75',
        metric: 'percent',
      },
    ]
  }.freeze
end
