require 'rails_helper'

describe 'Admin can delete league', type: :feature do
  include Warden::Test::Helpers
  
  let(:membership) { create(:membership, role: role) }
  let(:league) { membership.league }
  let(:league_name) { league.name }
  let(:user) { membership.user }
  
  describe 'for admin on league' do
    let(:role) { 1 }
    
    before { login_as(user, scope: :user) }
    
    it 'delete the league and redirect to dashboard' do
      visit league_path(league)
      
      click_button "Delete league"
      
      expect(current_path).to eq(dashboard_path)
      expect(page).not_to have_content(league_name)
    end
  end
end