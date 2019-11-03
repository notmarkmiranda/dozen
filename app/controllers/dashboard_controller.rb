class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @leagues = current_user.leagues.decorate
  end
end