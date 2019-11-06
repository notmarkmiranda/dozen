require 'rails_helper'

describe 'Creating new league creates initial season', type: :feature do
  let(:user) { create(:user) }
  
  before { login_as(user, scope: :user) }
  
  it 'shows one season on league#show' do
    visit new_league_path
    
    fill_in "Name", with: "Super Duper!"
    fill_in "Location", with: "Your mom's house"
    
    click_button "Create League"
    
    expect(current_path).to eq(dashboard_path)
    
    visit league_path(League.last)
    
    expect(page).to have_content("Seasons: 1")
  end
end