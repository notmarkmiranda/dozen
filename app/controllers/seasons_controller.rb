class SeasonsController < ApplicationController
  before_action :load_and_authorize_season, except: [:create]

  def show
    @standings = @season.standings
  end

  def create
    @league = League.find(season_params[:league_id])
    authorize @league, policy_class: SeasonPolicy
    return confirmation if @league.seasons.any_active?
    if @league.seasons.create!
      flash[:alert] = "New season created."
    else
      # NOTE: not sure we could ever hit this?
      flash[:alert] = "Something went wrong."
    end
    redirect_to @league
  end

  def destroy
    league = @season.league
    @season.destroy
    redirect_to league
  end

  # NON-REST ACTIONS :(
  def complete
    @season.deactivate_and_complete!
    redirect_to @season.league
  end

  def confirm; end

  def count
    @season.count!
    redirect_to @season
  end

  def deactivate
    league = @season.league
    league.seasons.deactivate_all!
    league.seasons.create!
    flash[:alert] = "New season created!"
    redirect_to league_path(league)
  end

  def leave
    league = @season.league
    league.seasons.create!(active_season: false)
    flash[:alert] = "Inactive season created!"
    redirect_to league_path(league)
  end

  def uncomplete
    @season.activate_and_uncomplete!
    redirect_to @season.league
  end

  def uncount
    @season.uncount!
    redirect_to @season
  end

  private

  def season_params
    params.require(:season).permit(:league_id, :active_season, :completed)
  end

  def confirmation
    redirect_to season_confirm_path(@league.active_season)
  end

  def load_and_authorize_season
    id = params[:id] || params[:season_id]
    @season = Season.find(id).decorate
    authorize @season
  end
end
