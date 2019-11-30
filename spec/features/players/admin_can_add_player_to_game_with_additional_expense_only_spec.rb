require 'rails_helper'

describe 'Admin can add player to game with additional expense only', type: :feature do
  let(:game) { create(:game, completed: false) }
  let(:league) { game.season_league }
  let!(:player) { create(:player, game: game, finished_at: Time.now.utc, finishing_order: 1) }

  before { player.user.update(first_name: 'super', last_name: 'duper') }

  describe 'when user' do
    let(:membership) { create(:membership, role: role, league: league) }
    let(:user) { membership.user.decorate }

    before { login_as(user, scope: :user) }

    describe 'is admin' do
      let(:role) { 1 }

      it 'creates a player with only an additional expense only and displays them below finished players' do
        visit game_path(game)

        find('#player-select').find(:xpath, 'option[2]').select_option
        fill_in 'Rebuy or Add-on', with: '1250'
        click_button 'Add Rebuy or Add-on Only'

        expect(current_path).to eq(game_path(game))
        within('tr.rebuyer') do
          expect(page).to have_content(user.full_name)
          expect(page).to have_content('$1,250')
        end
        within('table.game-standings') do
          expect(page).not_to have_content(user.full_name)
        end
      end
    end

    describe 'is member'
  end
end
