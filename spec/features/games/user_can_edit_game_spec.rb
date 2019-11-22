require 'rails_helper'

describe 'Admin can edit game', type: :feature do
  let(:membership) { create(:membership, role: role) }
  let(:league) { membership.league }
  let(:user) { membership.user }
  let(:active_season) { league.active_season }
  let(:game) { create(:game, season: active_season) }

  before { login_as(user, scope: :user) }

  describe 'for admin on league' do
    let(:role) { 1 }

    it 'updates the game and redirects to game path' do
      visit game_path(game)
      
      click_link 'Edit game'
      fill_in 'Buy in', with: '299'
      click_button 'Update Game'

      expect(current_path).to eq(game_path(game))
      expect(page).to have_content('$299')
      expect(page).not_to have_content('$100')
    end
  end

  describe 'from member on league' do
    let(:role) { 0 }

    it 'does not show an edit game link' do
      visit game_path(game)

      expect(current_path).to eq(game_path(game))
      expect(page).to have_content(league.name)
      expect(page).not_to have_link('Edit game')
    end
  end
end
