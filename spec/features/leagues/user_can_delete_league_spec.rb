require 'rails_helper'

describe 'Admin can delete league', type: :feature, js: true do
  let(:membership) { create(:membership, role: role) }
  let(:league) { membership.league }
  let(:league_name) { league.name }
  let(:user) { membership.user }

  before { login_as(user, scope: :user) }

  describe 'for admin on league' do
    let(:role) { 1 }

    it 'delete the league and redirect to dashboard' do
      visit league_path(league)

      click_button "Delete league"
      page.driver.browser.switch_to.alert.accept
      sleep(1)

      expect(current_path).to eq(dashboard_path)
      expect(page).not_to have_content(league_name)
    end
  end

  describe 'for member on league' do
    let(:role) { 0 }

    it 'does not show the delete button' do
      visit league_path(league)

      expect(page).to have_content(league.name)
      expect(page).not_to have_button('Delete league')
    end
  end
end
