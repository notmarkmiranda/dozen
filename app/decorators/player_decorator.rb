class PlayerDecorator < ApplicationDecorator
  delegate_all

  def additional_amount_text
    h.number_to_currency(additional_expense, precision: 0)
  end

  def order_in_place(index=nil, total_players)
    return player.finishing_place if game.completed?
    return "Last" if index.zero? && total_players == 1
    return "Last" if (index + 1) == total_players
    return "First" if index.zero?
  end

  def user_full_name
    user&.decorate&.full_name
  end

  private

  def game
    player.game
  end
end
