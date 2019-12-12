class PlayersController < ApplicationController
  def create
    pc = PlayerCreator.new(player_params, params[:commit], current_user)
    if pc.save
      flash[:alert] = "Player finished"
    else
      flash[:alert] = pc.errors.join(', ')
    end
    redirect_to pc.game
  end

  def edit
    @player = Player.find(params[:id])
  end

  def update
    player = Player.find(params[:id])
    pu = PlayerUpdater.new(current_user, player, params[:commit], params_filter)
    if pu.save
      flash[:alert] = pu.flash_alert
    else
      flash[:alert] = pu.errors.join(', ')
    end
    redirect_to pu.game
  end

  def destroy
    player = Player.find(params[:id])
    pu = PlayerUpdater.new(current_user, player, params[:commit])
    pu.save
    flash[:alert] = pu.flash_alert
    redirect_to pu.game
  end

  private

  def params_filter
    params[:player] ? player_params : nil
  end

  def player_params
    params.require(:player).permit(
      :game_id,
      :user_id,
      :finishing_place,
      :score,
      :additional_expense,
      :finished_at
    )
  end
end
