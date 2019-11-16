require 'rails_helper'

describe 'User can toggle count_in_standings on season', type: :feature do
  let(:season) { create(:season) }
  let(:league) { season.league }
  let(:membership) { create(:membership, league: league, role: 1) }
  let(:user) { membership.user }

  before { login_as(user, scope: :user) }

  describe 'when season#count_in_standings is true' do
    before { season.count! }

    it 'allows admin to toggle #count_in_standings to false' do
      visit season_path(season)

      click_link 'Off'

      expect(current_path).to eq(season_path(season))
      expect(page).to have_css('a#on-button.inactive')
      expect(page).to have_css('a#off-button.active')
    end
  end

  describe 'when season#count_in_standings is false' do
    before { season.count! }

    it 'allows admin to oggle #count_in_standings to true' do
      visit season_path(season)

      click_link 'On'

      expect(current_path).to eq(season_path(season))
      expect(page).to have_css('a#on-button.active')
      expect(page).to have_css('a#off-button.inactive')
    end
  end
end
