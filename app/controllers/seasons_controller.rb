class SeasonsController < ApplicationController
  def show
    @season = Season.find(params[:id])
    authorize @season
  end

  def create
    @league = League.find(season_params[:league_id])
    return confirmation if @league.seasons.any_active?
    if @league.seasons.create!
      flash[:alert] = "New season created."
    else
      # NOTE: not sure we could ever hit this?
      flash[:alert] = "Something went wrong."
    end
    redirect_to @league
  end

  def confirm
    @season = Season.find(params[:season_id])
  end

  def deactivate
    league = Season.find(params[:season_id]).league
    league.seasons.deactivate_all!
    league.seasons.create!
    flash[:alert] = "New season created!"
    redirect_to league_path(league)
  end

  def leave
    league = Season.find(params[:season_id]).league
    league.seasons.create!(active_season: false)
    flash[:alert] = "Inactive season created!"
    redirect_to league_path(league)
  end

  private

  def confirmation
    redirect_to season_confirm_path(@league.active_season)
  end

  def season_params
    params.require(:season).permit(:league_id, :active_season, :completed)
  end
end
