class SettingsController < ApplicationController
  before_action :load_and_authorize_season

  def update_settings
    setting = @season.settings.first
    setting.update(setting_params)
    redirect_to season_path(@season)
  end

  private

  def load_and_authorize_season
    @season = Season.find(params[:id]).decorate
    authorize @season
  end

  def setting_params
    params.require(:setting).permit(:value)
  end
end
