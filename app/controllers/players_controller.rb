class PlayersController < ApplicationController
  def create
    pc = PlayerCreator.new(player_params)
    if pc.save
      flash[:alert] = "Player finished"
    else
      flash[:alert] = pc.errors.join(', ')
    end
    redirect_to pc.game
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
