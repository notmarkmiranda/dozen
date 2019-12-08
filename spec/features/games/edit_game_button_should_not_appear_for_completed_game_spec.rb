require 'rails_helper'

describe 'Edit game link should not appear for completed game', type: :feature do
  let(:game) { create(:game, completed: true) }
  let(:league) { game.season_league }
  let(:membership) { create(:membership, role: 1, league: league) }
  let(:user) { membership.user }

  before { login_as(user, scope: :user) }

  it 'does not have the link present if a game is completed' do
    visit game_path(game)

    expect(page).to have_content(league.name)
    expect(page).not_to have_link('Edit game')
  end
end
