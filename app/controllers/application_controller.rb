class ApplicationController < ActionController::Base
  include Pundit

  rescue_from ActiveRecord::RecordNotFound, with: :on_record_not_found
  rescue_from AbstractController::ActionNotFound, with: :on_record_not_found
  rescue_from ActionController::RoutingError, with: :on_routing_error
  rescue_from Pundit::NotAuthorizedError, with: :on_access_denied

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_user_location!, if: :storable_location?

  def render_404
    render 'application/404', status: 404
  end

  def on_access_denied
    render 'application/401', status: 401
  end

  def on_record_not_found
    render_404
  end

  def on_routing_error
    render_404
  end

  protect_from_forgery

  def after_sign_in_path_for(resource)
    if resource.first_name?
      stored_location_for(resource) || dashboard_path
    else
      user_complete_profile_path
    end
  end

  def after_sign_out_path_for(resource)
    stored_location_for(resource) || new_user_session_path
  end

  def user_root_path
    dashboard_path
  end

  protected

  def current_user
    super&.decorate
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :email, :password, :current_password) }
  end

  private

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end
end
