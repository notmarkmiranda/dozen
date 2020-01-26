class User < ApplicationRecord
  self.implicit_order_column = 'created_at'

  has_many :memberships
  has_many :leagues, through: :memberships
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  def admin_leagues
    memberships.where(role: 1).map(&:league)
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

  private

  def games_in_order(limit: nil, order: :asc)
    Game.joins(:players)
      .where('players.user_id = ?', self.id)
      .order(date: order)
      .limit(limit)
  end
end
