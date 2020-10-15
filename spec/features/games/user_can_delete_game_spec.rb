require 'rails_helper'

describe 'Admin can delete game', type: :feature, js: true do
  let(:membership) { create(:membership, role: role) }
  let(:league) { membership.league }
  let(:league_name) { league.name }
  let(:user) { membership.user }

  let(:game) { create(:game, season: league.active_season) }

  before { login_as(user, scope: :user) }

  describe 'for admin on league' do
    let(:role) { 1 }

    it 'deletes the game and redirects to the active season' do
      visit game_path(game)

      click_button "Delete game"
      page.driver.browser.switch_to.alert.accept
      sleep(1)
      
      expect(current_path).to eq(league_path(league))
    end
  end

  describe 'for member on league' do
    let(:role) { 0 }

    it 'does not show delete button for game' do
      visit game_path(game)

      expect(page).to have_content(league.name)
      expect(page).not_to have_button('Delete game')
    end
  end
end
