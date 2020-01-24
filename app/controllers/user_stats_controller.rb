class UserStatsController < ApplicationController
  def show
    @user = User.find(params[:id])
    authorize @user, policy_class: UserStatsPolicy
  end
end