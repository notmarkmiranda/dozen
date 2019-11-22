class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id]).decorate
    authorize @game
  end

  def new
    season = Season.find(game_params[:season_id])
    @game = season.games.new
    authorize @game
  end

  def create
    @game = Game.new(game_params)
    authorize @game
    if @game.save
      flash[:alert] = "Game has been scheduled"
      redirect_to @game
    else
      flash[:alert] = "Something went wrong"
    end
  end

  def edit
    @game = Game.find(params[:id])
    authorize @game
  end

  def update
    @game = Game.find(params[:id])
    authorize @game
    if @game.update(game_params)
      flash[:alert] = "Game updated"
      redirect_to @game
    else
      flash[:alert] = "Something went wrong"
      render :edit
    end
  end

  def destroy
    game = Game.find(params[:id])
    authorize game
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