class UserStatsController < ApplicationController
  before_action :set_user
  
  def show
    # authorize @user, policy_class: UserStatsPolicy
    @user_stats = true
  end

  def games
    @leagues = League.joins(:memberships).where('memberships.user_id = ?', @user.id)
  end

  private

  def set_user
    @user = User.find(params[:id]).decorate
  end
end