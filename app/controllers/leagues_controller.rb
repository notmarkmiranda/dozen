class LeaguesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  
  def show
    @league = League.find(params[:id])
    authorize @league
  end
  
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
  
  def destroy
    @league = League.find(params[:id])
    authorize @league
    @league.destroy
    redirect_to dashboard_path
  end
  
  private
  
  def league_params
    params.require(:league)
      .permit(:name, :location, :public_league)
      .merge(user_id: current_user.id)
  end
end