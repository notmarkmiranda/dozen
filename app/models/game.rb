class Game < ApplicationRecord
  self.implicit_order_column = 'created_at'

  validates :buy_in, presence: true
  belongs_to :season, optional: true
  belongs_to :league, optional: true
  has_many :players, dependent: :destroy

  serialize :payout_schedule
  
  delegate :league, to: :season, prefix: true

  scope :completed, -> { where(completed: true) }
  scope :in_date_order, -> { order(date: :asc) }
  scope :in_reverse_date_order, -> { order(date: :desc) }
  scope :incompleted, -> { where('games.completed = ? AND date >= ?', false, Date.today).order(date: :asc) }

  def available_players
    all_users = season_league.memberships.map(&:user)
    available_users = (all_users - finished_players.map(&:user) - rebuyers.map(&:user))

    decorated_users = UserDecorator.decorate_collection(available_users).sort_by(&:full_name)
    decorated_users.collect { |user| [user.full_name, user.id] }
  end

  def estimated_total_pot
    buy_in * estimated_players_count + players.sum(:additional_expense)
  end

  def game_number_in_season
    season.games.in_date_order.index(self) + 1
  end

  def not_completed?
    !completed?
  end

  def payout(place)
    percentage = payout_schedule[place].to_f / 100
    return estimated_total_pot * percentage unless completed?
    total_pot * percentage
  end

  def player_finishing_place(user_id, controller_name)
    return unless controller_name == 'user_stats'
    players.find_by_user_id(user_id)&.finishing_place
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
    buy_in * players_count + players.sum(:additional_expense)
  end
end
