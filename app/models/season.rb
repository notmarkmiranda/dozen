class Season < ApplicationRecord
  include Settable

  enum scoring_system: { points: 0, net_earnings: 1 }
  after_create :add_all_settings
  
  self.implicit_order_column = 'created_at'

  belongs_to :league
  has_many :games
  has_many :players, through: :games

  scope :in_created_order, -> { order(created_at: :asc) }

  def activate!
    # TODO: deactivate other seasons?
    update!(active_season: true)
  end

  def activate_and_uncomplete!
    activate! && uncompleted!
  end

  def completed!
    update!(completed: true)
  end

  def count!
    update!(count_in_standings: true)
  end

  def deactivate!
    update!(active_season: false)
  end

  def deactivate_and_complete!
    deactivate! && completed!
  end

  def games_count
    games.count
  end

  def games_for_user(user_id)
    games.joins(:players).where('players.user_id = ?', user_id).order(date: :asc).decorate
  end

  def games_in_reverse_date_order(limit=nil)
    games.order(date: :desc).limit(limit).decorate
  end

  def last_completed_game
    games.in_reverse_date_order.where(completed: true).limit(1).last&.decorate
  end

  def leader
    standings(1).first
  end

  def next_scheduled_game
    games.incompleted.first&.decorate
  end
  
  def not_completed?
    !completed?
  end

  def number_in_order
    number = league.seasons.index(self) + 1
    number
  end

  def uncompleted!
    update!(completed: false)
  end

  def uncount!
    update!(count_in_standings: false)
  end

  def user_rank(user_id)
    return unless user_id
    standings = Standings::StandingsCompiler.standings(self, nil)
    return 'N/A' unless standings
    index = standings.pluck(:user_id).index(user_id)
    return 'N/A' unless index
    index + 1
  end

  def self.any_active?
    find_by(active_season: true)
  end

  def self.deactivate_all!
    update_all(active_season: false)
  end

  def standings(limit=nil)
    return [] if players.empty? || games.completed.empty?
    Standings::StandingsCompiler.standings(self, limit)
  end

  def total_pot
    games.sum(&:total_pot)
  end
end
