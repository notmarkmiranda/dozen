require 'humanize'

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

  def user_display_name(current_user=nil)
    user&.decorate&.display_name(current_user)
  end
  def user_full_name
    user&.decorate&.full_name
  end

  def place(index)
    index + 1
  end
  
  def place_class(index)
    place(index).humanize
  end

  def total_games_played_by_object(league_or_season)
    klass = league_or_season.class
    return unless klass == LeagueDecorator || klass == SeasonDecorator
    league_or_season.players.where('players.user_id = ?', player.user_id).count
  end
  
  private

  def game
    player.game
  end
end
