require 'rails_helper'

describe 'User can create new league', type: :feature do
  let(:user) { create(:user) }
  let(:league_name) { "Super Duper League" }
  
  before { login_as(user, scope: :user) }
  
  it 'creates a new league from dashboard then redirects to dashboard' do
    visit dashboard_path
    
    click_link "Create New League"
    fill_in "Name", with: league_name
    fill_in "Location", with: "Denver, Colorado"
    page.check 'Public league'
    
    click_button "Create League"
    
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content(league_name)
  end
end