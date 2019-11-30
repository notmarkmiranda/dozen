class PlayersController < ApplicationController
  def create
    pc = PlayerCreator.new(player_params, params[:commit])
    if pc.save
      flash[:alert] = "Player finished"
    else
      flash[:alert] = pc.errors.join(', ')
    end
    redirect_to pc.game
  end

  def update
    player = Player.find(params[:id])
    pu = PlayerUpdater.new(player, params[:commit])
    if pu.save
      flash[:alert] = "Player update"
    else
      flash[:alert] = pu.errors.join(', ')
    end
    redirect_to pu.game
  end

  def destroy
    player = Player.find(params[:id])
    pu = PlayerUpdater.new(player, params[:commit])
    pu.save
    redirect_to pu.game
  end

  private

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
