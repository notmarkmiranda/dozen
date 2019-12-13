require 'rails_helper'

describe 'Admin can create user from game#show', type: :feature do
  let(:game) { create(:game) }
  let(:league) { game.season_league }
  let(:membership) { create(:membership, role: 1, league: league) }
  let(:user) { membership.user }

  before { login_as(user, scope: :user) }

  it 'creates a new user / membership and redirects back to game' do
    visit game_path(game)

    click_link 'Add new player'
    fill_in 'E-Mail Address', with: Faker::Internet.email
    fill_in 'First name', with: Faker::Name.first_name
    fill_in 'Last name', with: Faker::Name.last_name
    click_button 'Create player'

    expect(current_path).to eq(game_path(game))

    user = User.last.decorate

    select(user.full_name, from: 'player-select')
    click_button 'Finish player'
    within('tr.game-standing') do
      expect(page).to have_content(user.full_name)
    end
  end
end
