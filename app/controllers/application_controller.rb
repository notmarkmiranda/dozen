class ApplicationController < ActionController::Base
  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery

  # def after_sign_up_path_for(resource)
  #   user_complete_profile_path
  # end

  def after_sign_in_path_for(resource)
    if resource.first_name?
      dashboard_path
    else
      user_complete_profile_path
    end
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  def user_root_path
    dashboard_path
  end

  protected

  def current_user
    super&.decorate
  end

  def configure_permitted_parameters
     # devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password)}

     devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :email, :password, :current_password) }
  end
end
