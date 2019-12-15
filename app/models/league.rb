class League < ApplicationRecord
  self.implicit_order_column = 'created_at'

  attr_accessor :user_id

  validates :name, uniqueness: true, presence: true

  has_many :memberships, dependent: :destroy
  has_many :seasons, -> { in_created_order }, class_name: 'Season', dependent: :destroy
  has_many :games, through: :seasons

  after_create_commit :create_initial_admin
  after_create_commit :create_initial_season

  scope :public_leagues, -> { where(public_league: true).order(name: :asc) }

  def active_season
    seasons.find_by(active_season: true)
  end

  def last_completed_game
    games.in_reverse_date_order.where(completed: true).limit(1).last&.decorate
  end

  private

  def create_initial_admin
    return unless user_id
    memberships.create!(role: 1, user_id: user_id)
  end

  def create_initial_season
    return if seasons.any?
    seasons.create!(league: self, active_season: true, completed: false)
  end
end
