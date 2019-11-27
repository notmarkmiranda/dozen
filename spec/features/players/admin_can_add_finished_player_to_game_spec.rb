require 'rails_helper'

describe 'Admin can add finished player to game', type: :feature do
  let(:game) { create(:game, completed: false) }
  let(:league) { game.season_league }

  let!(:membership_2) { create(:membership, league: league, role: 0) }
  # let!(:user_2) { membership_2.user.decorate }

  describe 'when user' do
    let(:membership) { create(:membership, league: league, role: role) }
    let(:user) { membership.user }

    before { login_as(user, scope: :user) }

    describe 'is admin' do
      let(:role) { 1 }

      describe 'first player done' do
        it 'should redirect back to game_path and have player#user#truncated_name' do
          visit game_path(game)

          find('#player-select').find(:xpath, 'option[2]').select_option
          click_button('Finish player')

          expect(current_path).to eq(game_path(game))
          within('tr.game-standing') do
            expect(page).to have_content(Player.last.user_full_name)
          end
        end
      end

      describe 'for second player done' do
        before { create(:player, game: game, finishing_order: 1, finishing_place: nil) }

        it 'should create another player' do
          visit game_path(game)

          find('#player-select').find(:xpath, 'option[2]').select_option
          click_button 'Finish player'

          expect(current_path).to eq(game_path(game))
          standings = page.all("tr.game-standing")
          within(standings[0]) do
            expect(page).to have_content(Player.last.user_full_name)
          end
        end
      end
    end

    describe 'is member' do
      let(:role) { 0 }

      it 'should not have Finish player button' do
        visit game_path(game)

        expect(page).to have_content(league.name)
        expect(page).not_to have_button('Finish player')
      end
    end
  end
end
