class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user

  scope :in_place_order, ->  { order(finishing_order: :desc) }

  def additional_expense_commit?
    additional_expense == 0 ? :delete_player : :move_to_rebuyers
  end

  def calculate_score(players_count, buy_in)
    numerator = players_count * buy_in ** 2 / total_expense(buy_in)
    denominator = finishing_place + 1
    score = ((Math.sqrt(numerator) / denominator) * 1000).floor / 1000.0
    set_score(score)
  end

  def user_full_name
    user&.decorate&.full_name
  end

  private

  def set_score(score)
    update!(score: score)
  end

  def total_expense(buy_in)
    additional = additional_expense || 0
    additional + buy_in 
  end
end
