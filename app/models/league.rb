class League < ApplicationRecord
  self.implicit_order_column = 'created_at'

  attr_accessor :user_id

  validates :name, uniqueness: true, presence: true

  has_many :memberships, dependent: :destroy
  has_many :seasons, -> { in_created_order }, class_name: 'Season', dependent: :destroy
  has_many :games, through: :seasons
  has_many :players, through: :games

  after_create_commit :create_initial_admin
  after_create_commit :create_initial_season

  scope :public_leagues, -> { where(public_league: true).order(name: :asc) }

  def active_season
    seasons.find_by(active_season: true)
  end

  def average_pot_calculated
    games.completed.sum(&:total_pot) / completed_games_count
  end

  def completed_games_count
    games.completed.count
  end

  def first_game
    games_in_date_order(1).first
  end

  def games_count
    games.count
  end

  def games_in_reverse_date_order(limit=nil)
    games_in_order(limit: limit, order: :desc)
  end

  def games_in_date_order(limit=nil)
    games_in_order(limit: limit, order: :asc)
  end
  
  def last_completed_game
    games_in_reverse_date_order.where(completed: true).limit(1).last&.decorate
  end

  def leader
    standings(1).first
  end

  def next_scheduled_game
    games.incompleted.first&.decorate
  end

  def seasons_count
    seasons.count
  end

  def standings(limit=nil)
    standings_limit = limit || 99
    all_players = seasons.where(count_in_standings: true).flat_map(&:players)

    return [] if all_players.empty?
    Standings::StandingsCompiler.standings(self, standings_limit)
  end

  def total_pot
    games.sum(&:total_pot)
  end

  private

  def games_in_order(limit: nil, order: :asc)
    Game.joins(:season)
      .where('seasons.league_id = ?', self.id)
      .order(date: order)
      .limit(limit)
  end

  def create_initial_admin
    return unless user_id
    memberships.create!(role: 1, user_id: user_id)
  end

  def create_initial_season
    return if seasons.any?
    seasons.create!(league: self, active_season: true, completed: false)
  end
end
