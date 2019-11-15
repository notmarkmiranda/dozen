require 'rails_helper'

describe 'User can mark season as complete', type: :feature do
  let(:league) { create(:league) }
  let(:season) { league.active_season }

  describe 'When user' do
    let(:membership) { create(:membership, league: league, role: role) }
    let(:user) { membership.user }

    before { login_as(user, scope: :user) }

    describe 'is admin' do
      let(:role) { 1 }

      describe 'if the season is not completed' do
        it 'redirects to league path and does not have an active season button' do
          visit season_path(season)

          click_button 'Complete Season'

          expect(current_path).to eq(league_path(league))
          expect(page).not_to have_link("Active season")
        end
      end

      describe 'if the season is already completed' do
        before { season.update(completed: true) }
        it 'shows an Uncomplete Season button instead of a Complete Season button' do
          visit season_path(season)

          expect(page).to have_button('Uncomplete and Activate Season')
          expect(page).not_to have_button('Complete Season')

          click_button('Uncomplete and Activate Season')

          expect(current_path).to eq(league_path(league))
          expect(page).to have_link('Active season')
        end
      end
    end

    describe 'is member' do
      let(:role) { 0 }

      describe 'if the season is not completed' do
        before { season.update!(completed: false) }

        it 'does not show a Complete Season button' do
          visit season_path(season)

          expect(current_path).to eq(season_path(season))
          expect(page).not_to have_button('Complete Season')
          expect(page).not_to have_button('Uncomplete and Activate Season')
        end
      end

      describe 'if the season is completed' do
        before { season.update!(completed: true) }

        it 'does not show a Complete Season button' do
          visit season_path(season)

          expect(current_path).to eq(season_path(season))
          expect(page).not_to have_button('Complete Season')
          expect(page).not_to have_button('Uncomplete and Activate Season')
        end
      end
    end
  end
end
