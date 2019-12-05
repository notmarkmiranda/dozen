require 'rails_helper'

describe 'Admin can edit finished player', type: :feature do
  let(:player) { create(:player, finishing_order: 1) }
  let(:game) { player.game }
  let(:user) { player.user }

  describe 'updates a finished player' do
    before { login_as(user, scope: :user) }

    let(:new_amount) { '120' }
    it 'updates a finished players additional expense' do
      visit game_path(game)

      all('.edit-finished').last.click

      expect(current_path).to eq(edit_player_path(player))

      fill_in 'Rebuy or Add-on', with: new_amount
      click_button 'Update player'

      expect(current_path).to eq(game_path(game))
      expect(page).to have_content('$120')
    end
  end
end
