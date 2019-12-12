require 'rails_helper'

describe 'Admin can remove finished player from game', type: :feature do
  let(:game) { create(:game, completed: false) }
  let(:league) { game.season_league }

  let!(:player) do
    create(
      :player,
      game: game,
      additional_expense: additional_expense,
      finished_at: Time.now.utc,
      finishing_place: nil,
      finishing_order: 1
    )
  end

  let(:membership) { create(:membership, league: league, role: role) }
  let(:user) { membership.user }

  describe 'when player has no additional expense' do
    let(:additional_expense) { 0 }

    describe 'when user' do
      before { login_as(user, scope: :user) }

      describe 'is admin' do
        let(:role) { 1 }

        it 'removes finished player from game' do
          visit game_path(game)

          find(:css, '.delete-button').click

          expect(current_path).to eq(game_path(game))
          expect(page).to have_content('Player deleted')
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

  describe 'when player has additional expense' do
    let(:additional_expense) { 100 }

    describe 'when user' do
      before { login_as(user, scope: :user) }

      describe 'is admin' do
        let(:role) { 1 }

        it 'moves the player from standings to rebuyers' do
          visit game_path(game)

          find(:css, '.delete-button').click

          expect(current_path).to eq(game_path(game))
          expect(page).to have_content(league.name)
          expect(page).to have_content('Player moved back to rebuyers')
          expect(page).not_to have_selector('tr.game-standing')

          last_player = Player.last.decorate
          within('tr.rebuyer') do
            expect(page).to have_content(last_player.user_full_name)
          end
        end
      end
    end
  end
end
