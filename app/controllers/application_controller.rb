class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  protected

  def current_user
    super&.decorate
  end
end
