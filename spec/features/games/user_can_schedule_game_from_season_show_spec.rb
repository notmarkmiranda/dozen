require 'rails_helper'

describe 'User can schedule game from season#show', type: :feature do
  let(:season) { create(:season) }
  let(:league) { season.league }
  let(:user) { create(:membership, league: league, role: 1).user }

  before { login_as(user, scope: :user) }

  it 'schedules game and redirects to game path' do
    visit season_path(season)

    click_link 'Schedule Game'
    fill_in 'Buy in', with: '1000'
    page.check 'Allows Rebuys or Add Ons'
    fill_in 'Address', with: '123 Fake St, Denver, CO 80219'
    fill_in 'Estimated Player Count', with: '15'
    fill_in '1st', with: '50'
    fill_in '2nd', with: '30'
    fill_in '3rd', with: '20'
    fill_in 'Date & Time', with: '09/05/2030'

    click_button 'Schedule Game'

    expect(current_path).to eq(game_path(Game.last))
    expect(page).to have_content('$1,000')
    expect(page).to have_content('May 9, 2030')
    expect(page).to have_content('Allows rebuys or add-ons')
    expect(page).to have_content('$7,500.00')
    expect(page).to have_content('$4,500.00')
    expect(page).to have_content('$3,000.00')
  end
end
