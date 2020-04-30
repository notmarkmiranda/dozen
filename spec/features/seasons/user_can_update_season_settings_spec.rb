require 'rails_helper'

describe 'User can update season settings', type: :feature do
  let(:membership) { create(:membership, role: 1) }
  let(:season) { membership.league.seasons.first }
  let(:user) { membership.user }

  before { login_as(user, scope: :user) }

  it 'allows a user to change settings' do
    visit settings_season_path(season)
    
    fill_in 'Percentage of games to count for playoffs', with: '90'
    click_button 'Update Settings'

    expect(current_path).to eq(season_path(season))
    expect(page).to have_content('Games Counted for Playoffs: 90%')
  end
end
