class UsersController < ApplicationController
  before_action :authenticate_user!

  def update
    return unless params[:commit].parameterize.underscore.to_sym == :complete_profile
    current_user.update(user_params)
    redirect_to dashboard_path
  end

  def complete_profile
    @user = current_user
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
