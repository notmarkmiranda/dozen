class Season < ApplicationRecord
  belongs_to :league

  def activate!
    update!(active_season: true)
  end

  def deactivate!
    update!(active_season: false)
  end

  def not_completed?
    !completed?
  end

  def self.any_active?
    find_by(active_season: true)
  end

  def self.deactivate_all!
    update_all(active_season: false)
  end
end
