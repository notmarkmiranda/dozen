class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user

  def additional_expense_commit?
    additional_expense == 0 ? :delete_player : :move_to_rebuyers
  end

  def user_full_name
    user&.decorate&.full_name
  end
end
