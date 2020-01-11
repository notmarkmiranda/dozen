class LeaguesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]

  def show
    @league = League.find(params[:id]).decorate
    authorize @league
    @standings = @league.standings(10)
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

  def edit
    @league = League.find(params[:id])
    authorize @league
  end

  def update
    @league = League.find(params[:id])
    authorize @league
    if @league.update(league_params)
      flash[:alert] = "League updated"
      redirect_to @league
    else
      flash[:alert] = "Something went wrong"
      render :edit
    end
  end

  def destroy
    @league = League.find(params[:id])
    authorize @league
    @league.destroy
    redirect_to dashboard_path
  end

  def public_leagues
    @leagues = League.public_leagues.decorate
  end

  def new_user
    @user = User.new
    @league = League.find(params[:id])
  end

  def create_user
    league = League.find(params[:id])
    authorize league
    uc = UserCreator.new(league_user_params, league)
    uc.save
    flash[:alert] = uc.alerts.join(', ')
    redirect_to league
  end

  private

  def league_params
    params.require(:league)
      .permit(:name, :location, :public_league)
      .merge(user_id: current_user&.id)
  end

  def league_user_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name
    )
  end
end
