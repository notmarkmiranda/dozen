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
    fill_in 'Date & Time', with: '09/05/2030, 07:00 PM'

    click_button 'Schedule Game'

    expect(current_path).to eq(game_path(Game.last))
    expect(page).to have_content('$1,000')
    expect(page).to have_content('May 9, 2030 at 7:00 PM')
    expect(page).to have_content('Allows rebuys or add-ons')
  end
end
