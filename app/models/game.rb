class Game < ApplicationRecord
  self.implicit_order_column = 'created_at'

  validates :buy_in, presence: true
  belongs_to :season, optional: true
  belongs_to :league, optional: true
  has_many :players, dependent: :destroy

  delegate :league, to: :season, prefix: true

  scope :in_date_order, -> { order(date: :asc) }
  scope :in_reverse_date_order, -> { order(date: :desc) }
  scope :incompleted, -> { where('games.completed = ? AND date >= ?', false, Date.today).order(date: :asc) }

  def available_players
    all_users = season_league.memberships.map(&:user)
    available_users = (all_users - finished_players.map(&:user) - rebuyers.map(&:user))

    decorated_users = UserDecorator.decorate_collection(available_users).sort_by(&:full_name)
    decorated_users.collect { |user| [user.full_name, user.id] }
  end

  def not_completed?
    !completed?
  end

  def players_count
    players.count
  end

  def players_except_self(player)
    players.where.not(id: player.id)
  end

  def rebuyers
    players.where('additional_expense > ? AND finishing_place IS ? AND finishing_order IS ?', 0, nil, nil)
  end

  def finished_players
    ActiveSupport::Deprecation.silence do
      players.where.not(id: nil, finishing_order: nil).order(finishing_order: :desc).decorate
    end
  end

  def total_pot
    buy_in * players_count + players.sum(&:additional_expense)
  end
end
