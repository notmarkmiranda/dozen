class UsersController < ApplicationController
  before_action :authenticate_user!

  def update
    return unless params[:commit].parameterize.underscore.to_sym == :complete_profile && current_user.id == params[:id].to_i
    current_user.update(user_params)
  end

  def complete_profile
    @user = current_user
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
