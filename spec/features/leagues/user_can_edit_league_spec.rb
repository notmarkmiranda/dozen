require 'rails_helper'

describe 'Admin can edit league', type: :feature do
  include Warden::Test::Helpers
  
  let(:membership) { create(:membership, role: role) }
  let(:league) { membership.league }
  let(:user) { membership.user }
  
  let(:old_name) { league.name }
  let(:new_name) { "New League Name" }
  
  before { login_as(user, scope: :user) }
  
  describe 'for admin on league' do
    let(:role) { 1 }
    
    
    it 'should edit the league and redirect to league path' do
      visit league_path(league)
      
      click_link "Edit league"
      fill_in "Name", with: new_name
      click_button "Update League"

      expect(current_path).to eq(league_path(league))
      expect(page).to have_content(new_name)
      expect(page).not_to have_content(old_name)
    end
  end
  
  describe 'for member on league' do
    let(:role) { 0 }
    
    it 'should not show the edit button' do
      visit league_path(league)
      
      expect(page).to have_content(old_name)
      expect(page).not_to have_link('Edit league')
    end
  end
end