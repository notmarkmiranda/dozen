require 'rails_helper'

describe 'User can delete season', type: :feature, js: true do
  let(:season) { create(:season) }
  let(:league) { season.league }

  describe 'When user' do
    let(:membership) { create(:membership, league: league, role: role) }
    let(:user) { membership.user }
    let!(:season_count) { league.seasons.count - 1 }

    before { login_as(user, scope: :user) }

    describe 'is admin' do
      let(:role) { 1 }

      it 'deletes season and redirects to league path' do
        visit season_path(season)

        click_button 'Delete Season'
        page.driver.browser.switch_to.alert.accept
        sleep(0.1)

        expect(current_path).to eq(league_path(league))
        expect(page).to have_content("Seasons: #{season_count}")
      end
    end

    describe 'is user' do
      let(:role) { 0 }

      it 'does not show a delete button' do
        visit season_path(season)

        expect(current_path).to eq(season_path(season))
        expect(page).not_to have_button('Delete Season')
      end
    end
  end
end
