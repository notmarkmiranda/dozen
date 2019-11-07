class Season < ApplicationRecord
  belongs_to :league
  
  def deactivate!
    update!(active_season: false)
  end
  
  def self.any_active?
    find_by(active_season: true)
  end
  
  def self.deactivate_all!
    update_all(active_season: false)
  end
end
