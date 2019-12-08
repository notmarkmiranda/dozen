require 'rails_helper'

describe 'Admin can complete game', type: :feature do
  let(:game) { create(:game, buy_in: 15) }
  let(:league) { game.season_league }
  let(:membership) { create(:membership, league: league, role: 1) }
  let(:user) { membership.user }
  let!(:player_1) { create(:player, game: game, finishing_order: first_order, additional_expense: 0, finishing_place: nil) }
  let!(:player_2) { create(:player, game: game, finishing_order: second_order, additional_expense: 1, finishing_place: nil) }
  let(:first_place_score) { 2.645 }
  let(:second_place_score) { 1.825 }

  describe 'when admin' do
    before { login_as(user, scope: :user) }

    describe 'when all players have a finishing order' do
      let(:first_order) { 1 }
      let(:second_order) { 2 }

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

    describe 'when not all players have a finishing order' do
      let(:first_order) { 1 }
      let(:second_order) { nil }

      it 'does not complete the game' do
        visit game_path(game)

        click_button 'Complete game'

        expect(current_path).to eq(game_path(game))
        expect(page).to have_content(player_1.user_full_name) 
        expect(page).not_to have_content(first_place_score)
        expect(page).to have_content(player_2.user_full_name)
        expect(page).not_to have_content(second_place_score)
        expect(page).to have_button('Complete game')
      end
    end

    describe 'when there are no finished players' do
      let(:first_order) { nil }
      let(:second_order) { nil }

      before { game.players.destroy_all}

      it 'does not complete the game' do
        visit game_path(game)

        click_button 'Complete game'
        expect(current_path).to eq(game_path(game))
        expect(page).to have_button('Complete game')
        expect(page).not_to have_button('Uncomplete game')
      end
    end

    describe 'when there is only one finished player' do
      let(:first_order) { 1 }
      let(:second_order) { 2 }
      
      before { game.players.last.destroy }

      it 'does not complete the game' do
        visit game_path(game)

        click_button 'Complete game'
        expect(current_path).to eq(game_path(game))
        expect(page).to have_button('Complete game')
        expect(page).not_to have_button('Uncomplete game')
      end
    end
  end
end
