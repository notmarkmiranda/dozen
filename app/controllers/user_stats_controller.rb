class UserStatsController < ApplicationController
  def show
    @user = User.find(params[:id]).decorate
    authorize @user, policy_class: UserStatsPolicy
    @user_stats = true
  end
end