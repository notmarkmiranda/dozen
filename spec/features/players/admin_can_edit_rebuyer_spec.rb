require 'rails_helper'

describe 'Admin can edit rebuyer', type: :feature do
  let(:player) { create(:player, additional_expense: 1, finishing_order: nil, finishing_place: nil) }
  let(:game) { player.game }
  let(:user) { player.user }

  describe 'updates a rebuyer' do
    before { login_as(user, scope: :user) }

    let(:new_amount) { '120' }

    it 'updates a finished players additional expense' do
      visit game_path(game)

      all('.edit-rebuyer').last.click

      expect(current_path).to eq(edit_player_path(player))

      fill_in 'Rebuy or Add-on', with: new_amount
      click_button 'Update player'

      expect(current_path).to eq(game_path(game))
      expect(page).to have_content('$120')
    end
  end
end
