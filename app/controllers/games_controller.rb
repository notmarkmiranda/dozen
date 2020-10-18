class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id]).decorate
    authorize @game
    @player = @game.players.new
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
    redirect_to league
  end

  def complete
    @game = Game.find(params[:id])
    authorize @game
    gc = GameCompleter.new(@game, params[:action])
    gc.save
    flash[:alert] = gc.alerts.join(', ')
    redirect_to @game
  end

  def uncomplete
    @game = Game.find(params[:id])
    authorize @game
    gc = GameCompleter.new(@game, params[:action])
    gc.save
    flash[:alert] = gc.alerts.join(', ')
    redirect_to @game
  end

  def new_user
    @user = User.new
    @game = Game.find(params[:id])
  end

  def create_user
    game = Game.find(params[:id])
    authorize game
    uc = UserCreator.new(game_user_params, game)
    uc.save
    flash[:alert] = uc.alerts.join(', ')
    redirect_to game
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
      :estimated_players_count,
      :date,
      payout_schedule: {}
    )
  end

  def game_user_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name
    )
  end

end
