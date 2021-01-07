class Player < ApplicationRecord
  PAYOUT_KEYS = {
    "1" => "first",
    "2" => "second",
    "3" => "third"
  }.freeze

  self.implicit_order_column = 'created_at'

  belongs_to :game
  belongs_to :user

  scope :in_place_order, ->  { order(finishing_order: :desc).decorate }
  scope :by_season, -> (season) { joins(:game).where("games.season_id = ?", season.id) }
  scope :completed_games, -> { joins(:game).where("games.completed = ?", true) }

  validates :game, uniqueness: { scope: :user_id }
  validate :finishing_order_or_additional_expense

  def additional_expense_commit
    return :delete_player if additional_expense == 0 || additional_expense.nil?
    :move_to_rebuyers
  end

  def calculate_payout
    schedule_key = PAYOUT_KEYS[finishing_place.to_s]
    return if schedule_key.nil?
    percentage = game.payout_schedule[schedule_key].to_f / 100
    winnings = game.total_pot * percentage
    set_payout(winnings)
  end

  def calculate_score(players_count, buy_in)
    numerator = players_count * buy_in ** 2 / total_expense(buy_in)
    denominator = finishing_place + 1
    score = ((Math.sqrt(numerator) / denominator))
    set_score(score)
  end

  def net_earnings_by_season(season)
    players = self.user.players.by_season(season).completed_games
    players.earnings - players.expenses
  end

  def self.earnings
    sum(&:payout)
  end

  def self.expenses
    sum { |player| player.game.buy_in + player.additional_expense }
  end

  def total_expense(buy_in=nil)
    additional = additional_expense || 0
    additional + (buy_in || game.buy_in)
  end

  private

  def finishing_order_or_additional_expense
    if (additional_expense.nil? || additional_expense.zero?) && finishing_order.nil?
      errors.add(:additional_expense, 'cannot be blank')
    end
  end

  def set_payout(winnings)
    update!(payout: winnings)
  end
  
  def set_score(score)
    update!(score: score)
  end
end
