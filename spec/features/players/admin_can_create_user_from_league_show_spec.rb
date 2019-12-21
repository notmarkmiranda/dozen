require 'rails_helper'

describe 'Admin can create user from league#show', type: :feature do
  let(:league) { create(:league) }
  let(:membership) { create(:membership, role: 1, league: league) }
  let(:user) { membership.user }

  before { login_as(user, scope: :user) }

  it 'creates a new user / membership and redirects to league' do
    visit league_path(league)

    click_link 'Add new player'
    fill_in 'E-Mail Address', with: Faker::Internet.email
    fill_in 'First name', with: Faker::Name.first_name
    fill_in 'Last name', with: Faker::Name.last_name
    click_button 'Create player'

    expect(current_path).to eq(league_path(league))
  end
end
