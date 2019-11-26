require 'rails_helper'

describe 'Admin can finish player with additional expense', type: :feature do
  let(:game) { create(:game) }
  let(:league) { game.season_league }
  let!(:player) { create(:player, game: game, finishing_place: nil, additional_expense: 123, finishing_order: nil) }

  describe 'when user' do
    let(:membership) { create(:membership, league: league, role: role) }
    let(:user) { membership.user }

    before { login_as(user, scope: :user) }

    describe 'is admin' do
      let(:role) { 1 }

      it 'moves a player from additional expense to finished set' do
        visit game_path(game)

        find(:css, '.finish-additional-button').click

        expect(current_path).to eq(game_path(game))
        expect(page).to have_content(league.name)
        within('table.game-rebuyers') do
          expect(page).not_to have_content(player.user_full_name)
        end
        within('table.game-standings') do
          expect(page).to have_content(player.user_full_name)
        end
      end
    end
  end
end
