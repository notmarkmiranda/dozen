class Season < ApplicationRecord
  belongs_to :league

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

  def deactivate!
    update!(active_season: false)
  end

  def deactivate_and_complete!
    deactivate! && completed!
  end

  def uncompleted!
    update!(completed: false)
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
