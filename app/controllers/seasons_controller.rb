class SeasonsController < ApplicationController
  def create
    @league = League.find(season_params[:league_id])
    return confirmation if @league.seasons.any_active?
    if @league.seasons.create!
      flash[:alert] = "New season created."
    else
      flash[:alert] = "Something went wrong."
    end
    redirect_to @league
  end
  
  def confirm
    # THIS IS WHERE YOU STOPPED
    # RENDER A VIEW HERE
    # REDIRECT BACK TO CREATE
    # OR CREATE NEW ACTIONS 
    # BASED ON WHAT WAS CHOSEN
  end
  
  private
  
  def confirmation
    redirect_to confirm_seasons_path(league: @league) 
  end
  
  def season_params
    params.require(:season).permit(:league_id, :active_season, :completed)
  end
end