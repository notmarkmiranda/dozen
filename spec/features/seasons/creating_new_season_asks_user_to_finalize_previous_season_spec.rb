require 'rails_helper'

describe 'Admin creating new season', type: :feature do
  let(:membership) { create(:membership, role: 1) }
  let(:league) { membership.league }
  let(:admin) { membership.user }
  let(:season) { league.active_season }
  
  describe 'when an admin is logged in' do
    before { login_as(admin, scope: :user) }
    
    describe 'while one is active' do
      describe 'asks if they want to deactivate the other' do
        before do
          visit league_path(league)
          
          click_button "Create new season"
          
          expect(page).to have_content("Do you want to deactivate your current season and create the new one? Or just create a new one without activating it?")
        end
        
        it 'clicking on deactivate current season' do
          click_button "Deactivate current season"
          
          expect(current_path).to eq(league_path(league))
          expect(page).to have_content("Seasons: 2")
        end
        
        it 'clicking on Leave current season' do
          click_button "Leave current season"
          
          expect(current_path).to eq(league_path(league))
          expect(page).to have_content("Seasons: 2")
        end
        
        it 'clicking on Cancel' do
          click_on "Cancel"
          
          expect(current_path).to eq(league_path(league))
          expect(page).to have_content("Seasons: 1")
        end
      end
    end
    
    describe 'no other active seasons' do
      before { season.deactivate! }
      
      it 'creates a new season and redirects to league#show' do
        visit league_path(league)
        
        click_button "Create new season"
        
        expect(current_path).to eq(league_path(league))
        expect(page).to have_content("Seasons: 2")
      end
    end
  end
end