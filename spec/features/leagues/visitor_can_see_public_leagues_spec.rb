require 'rails_helper'

describe 'Visitor can view public leagues', type: :feature do
  let!(:public_league) { create(:league, public_league: true) }
  let!(:private_league) { create(:league, public_league: false) }

  it 'visitor can only see public leagues' do
    visit public_leagues_path

    expect(page).to have_content(public_league.name)
    expect(page).not_to have_content(private_league.name)
  end
end
