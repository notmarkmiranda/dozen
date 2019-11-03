class LeaguesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  
  def new
    @league = League.new
  end
  
  def create
    @league = League.new(league_params)
    if @league.save
      flash[:alert] = "League created"
      redirect_to dashboard_path
    else
      flash[:alert] = "Something went wrong"
      render :new
    end
  end
  
  private
  
  def league_params
    params.require(:league).permit(:name, :location, :public_league)
  end
end