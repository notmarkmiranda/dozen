class League < ApplicationRecord
  attr_accessor :user_id
  
  validates :name, uniqueness: true
  
  has_many :memberships, dependent: :destroy
  has_many :seasons, dependent: :destroy
  
  after_create_commit :create_initial_admin
  after_create_commit :create_initial_season
  
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
