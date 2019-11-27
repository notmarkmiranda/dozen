require 'rails_helper'

describe 'Admin can remove finished player from game', type: :feature do
  let(:game) { create(:game, completed: false) }
  let(:league) { game.season_league }

  let!(:player) { create(:player, game: game, finished_at: Time.now.utc, finishing_place: nil, finishing_order: 1) }

  describe 'when user' do
    let(:membership) { create(:membership, league: league, role: role) }
    let(:user) { membership.user }

    before { login_as(user, scope: :user) }

    describe 'is admin' do
      let(:role) { 1 }

      it 'removes finished player from game' do
        visit game_path(game)

        find(:css, '.delete-button').click

        expect(current_path).to eq(game_path(game))
        expect(page).to have_content(league.name)
        expect(page).not_to have_selector('tr.game-standing')
      end
    end

    describe 'is member' do
      let(:role) { 0 }

      it 'does not have a delete button' do
        visit game_path(game)

        expect(page).to have_content(league.name)
        expect(page).not_to have_selector('btn.delete-button')
      end
    end
  end
end
