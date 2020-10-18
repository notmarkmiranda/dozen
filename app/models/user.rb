class User < ApplicationRecord
  self.implicit_order_column = 'created_at'

  has_many :memberships
  has_many :leagues, through: :memberships
  has_many :players
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  def admin_leagues
    memberships.where(role: 1).map(&:league)
  end

  def games_played
    Game.joins(:players).where('players.user_id = ?', id)
  end

  def games_won_played_count
    games_won = games_played.joins(:players).where('players.finishing_place = ?', 1).count
    games_played_count = games_played.count
    percentage = games_played_count.zero? ? 0.0 : (games_won / games_played_count.to_f) * 100
    { 
      played: games_played_count, 
      won: games_won, 
      percentage: percentage
    }
  end
  
  def league_count_by_role
    { admin: admin_leagues.count, member: member_leagues.count }
  end
  
  def member_leagues
    memberships.where(role: 0).map(&:league)
  end

  def games_in_reverse_date_order(limit=nil)
    games_in_order(limit: limit, order: :desc).decorate
  end

  def seasons_games_count
    seasons = Season.joins(:players).where('players.user_id = ?', id).distinct
    games_played_count = games_played.count
    total_games = seasons.sum(&:games_count)
    percentage = total_games.zero? ? 0.0 : (games_played_count / total_games.to_f) * 100
    {
      played: games_played_count,
      total: total_games,
      percentage: percentage
    }
  end

  private

  def games_in_order(limit: nil, order: :asc)
    Game.joins(:players)
      .where('players.user_id = ?', self.id)
      .order(date: order)
      .limit(limit)
  end
end
