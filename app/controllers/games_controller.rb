class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id]).decorate
  end

  def new
    season = Season.find(game_params[:season_id])
    @game = season.games.new
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      flash[:alert] = "Game has been scheduled"
      redirect_to @game
    else
      flash[:alert] = "Something went wrong"
    end
  end

  def destroy
    game = Game.find(params[:id])
    league = game.season.league
    authorize game
    game.destroy
    redirect_to league_path(league)
  end

  private

  def game_params
    params.require(:game).permit(
      :season_id,
      :league_id,
      :completed,
      :buy_in,
      :add_ons,
      :address,
      :players,
      :date
    )
  end
end
