class Game < ApplicationRecord
  validates :buy_in, presence: true
  belongs_to :season, optional: true
  belongs_to :league, optional: true
  has_many :players

  delegate :league, to: :season, prefix: true

  scope :in_date_order, -> { order(date: :asc) }
  scope :in_reverse_date_order, -> { order(date: :desc) }

  def available_players
    all_users = season_league.memberships.map(&:user)
    available_users = (all_users - saved_players.map(&:user))
    decorated_users = UserDecorator.decorate_collection(available_users).sort_by(&:full_name)
    decorated_users.collect { |user| [user.full_name, user.id] }
  end

  def not_completed?
    !completed?
  end

  def players_count
    players.count
  end

  def saved_players
    players.where.not(id: nil).order(finished_at: :desc).decorate
  end
end
