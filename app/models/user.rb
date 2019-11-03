class User < ApplicationRecord
  has_many :memberships
  has_many :leagues, through: :memberships
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  def admin_leagues
    memberships.where(role: 1).map(&:league)
  end
  
  def member_leagues
    memberships.where(role: 0).map(&:league)
  end
end
