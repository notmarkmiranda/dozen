class Player < ApplicationRecord
  self.implicit_order_column = 'created_at'

  belongs_to :game
  belongs_to :user

  scope :in_place_order, ->  { order(finishing_order: :desc).decorate }

  validates :game, uniqueness: { scope: :user_id }
  validate :finishing_order_or_additional_expense

  def additional_expense_commit
    return :delete_player if additional_expense == 0 || additional_expense.nil?
    :move_to_rebuyers
  end

  def calculate_score(players_count, buy_in)
    numerator = players_count * buy_in ** 2 / total_expense(buy_in)
    denominator = finishing_place + 1
    score = ((Math.sqrt(numerator) / denominator))
    set_score(score)
  end

  private

  def finishing_order_or_additional_expense
    # binding.pry
    if (additional_expense.nil? || additional_expense.zero?) && finishing_order.nil?
      errors.add(:additional_expense, 'cannot be blank')
    end
  end
  
  def set_score(score)
    update!(score: score)
  end

  def total_expense(buy_in)
    additional = additional_expense || 0
    additional + buy_in 
  end
end
