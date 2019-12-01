require 'rails_helper'

describe 'Admin can move player up in standings', type: :feature do
  let(:game) { create(:game) }
  let(:league) { game.season_league }
  before do
    @players = []
    2.times { |n| @players << create(:player, game: game, finishing_order: n + 1) }
  end

  describe 'when user' do
    let(:membership) { create(:membership, league: league, role: role) }
    let(:user) { membership.user }

    before { login_as(user, scope: :user) }

    describe 'is admin' do
      let(:role) { 1 }

      it 'moves a player up in standings' do
        visit game_path(game)

        standings = page.all("tr.game-standing")
        within(standings[0]) do
          expect(page).to have_content(@players[1].user_full_name)
        end
        within(standings[1]) do
          expect(page).to have_content(@players[0].user_full_name)
        end

        all('.move-down-standing').first.click

        expect(current_path).to eq(game_path(game))
        expect(page).to have_content(league.name)
        expect(page).to have_content('Player moved')
        standings = page.all("tr.game-standing")
        within(standings[0]) do
          expect(page).to have_content(@players[0].user_full_name)
        end
        within(standings[1]) do
          expect(page).to have_content(@players[1].user_full_name)
        end
      end
    end

    pending 'is member'
  end
end
