require 'rails_helper'

describe 'Admin can complete game', type: :feature do
  let(:game) { create(:game, buy_in: 15) }
  let(:league) { game.season_league }
  let(:membership) { create(:membership, league: league, role: 1) }
  let(:user) { membership.user }
  let!(:player_1) { create(:player, game: game, finishing_order: 1, additional_expense: 0) }
  let!(:player_2) { create(:player, game: game, finishing_order: 2, additional_expense: 0) }
  let(:first_place_score) { 2.738 }
  let(:second_place_score) { 1.825 }

  describe 'when admin' do
    before { login_as(user, scope: :user) }
    it 'redirects back to game path with scores' do
      visit game_path(game)

      click_button 'Complete game'

      expect(current_path).to eq(game_path(game))
      expect(page).to have_content(player_1.user_full_name) 
      expect(page).to have_content(first_place_score)
      expect(page).to have_content(player_2.user_full_name)
      expect(page).to have_content(second_place_score)
    end
  end
end
