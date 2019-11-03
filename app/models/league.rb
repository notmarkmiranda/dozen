class League < ApplicationRecord
  attr_accessor :user_id
  
  validates :name, uniqueness: true
  
  has_many :memberships
  
  after_create_commit :create_initial_admin
  
  private
  
  def create_initial_admin
    return unless user_id
    memberships.create!(role: 1, user_id: user_id)
  end
end
