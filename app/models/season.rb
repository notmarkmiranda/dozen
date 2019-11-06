class Season < ApplicationRecord
  belongs_to :league
  
  def self.any_active?
    find_by(active_season: true)
  end
  
  def deactivate!
    update!(active_season: false)
  end
end
