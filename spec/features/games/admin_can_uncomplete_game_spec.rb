require 'rails_helper'

describe 'Admin can uncomplete game', type: :feature do
  let(:game) { create(:game, completed: true) }
  let(:league) { game.season_league }
  let(:membership) { create(:membership, league: league, role: 1) }
  let(:user) { membership.user }
  let!(:player_1) { create(:player, game: game, finishing_order: 1, additional_expense: 0, finishing_place: 2, score: 1.825).decorate }
  let!(:player_2) { create(:player, game: game, finishing_order: 2, additional_expense: 1, finishing_place: 1, score: 2.645).decorate }

  before { login_as(user, scope: :user) }

  it 'redirects to game_path and puts finishers on standings table' do
    visit game_path(game)

    click_button 'Uncomplete game'

    expect(current_path).to eq(game_path(game))
    within('table.game-standings') do
      expect(page).to have_content(player_1.user_full_name)
      expect(page).to have_content(player_2.user_full_name)
    end
    expect(page).to have_button('Complete game')
    expect(page).not_to have_button('Uncomplete game')
  end
end
