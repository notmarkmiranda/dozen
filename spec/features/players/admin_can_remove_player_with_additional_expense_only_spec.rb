require 'rails_helper'

describe 'Admin can remove player with additional expense only', type: :feature do
  let(:game) { create(:game) }
  let(:league) { game.season_league }
  let!(:player) { create(:player, game: game, finishing_place: nil, additional_expense: 123, finishing_order: nil) }

  describe 'when user' do
    let(:membership) { create(:membership, league: league, role: role) }
    let(:user) { membership.user }

    before { login_as(user, scope: :user) }

    describe 'is admin' do
      let(:role) { 1 }

      it 'removes an unfinished player with additional expense from game' do
        visit game_path(game)

        find(:css, '.remove-additional-button').click

        expect(current_path).to eq(game_path(game))
        expect(page).to have_content(league.name)
        within('table.game-rebuyers') do
          expect(page).not_to have_content(player.user_full_name)
        end
      end
    end

    describe 'is member'
  end
end
