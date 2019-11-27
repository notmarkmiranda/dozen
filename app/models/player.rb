class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user

  def user_full_name
    user&.decorate&.full_name
  end
end
