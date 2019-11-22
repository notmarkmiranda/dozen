class Game < ApplicationRecord
  validates :buy_in, presence: true
  belongs_to :season, optional: true
  belongs_to :league, optional: true

  delegate :league, to: :season, prefix: true

  scope :in_date_order, -> { order(date: :asc) }
  scope :in_reverse_date_order, -> { order(date: :desc) }
end
