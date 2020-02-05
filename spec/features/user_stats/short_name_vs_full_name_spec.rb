require 'rails_helper'

describe 'short_name vs full_name', type: :feature do
  let(:first_name) { 'Mark' }
  let(:last_name) { 'Miranda' }

  let(:full_name) { "#{first_name} #{last_name}" }
  let(:short_name) { "#{first_name} #{last_name[0]}" }

  let(:player) { create(:player) }
  let(:object_league) { player.game.season_league }
  let(:object_user) { player.user }

  before { object_user.update(first_name: first_name, last_name: last_name) }

  describe 'Visitor only sees short name on user_stats#show' do
    it 'shows the user#short_name' do
      visit "/user-stats/#{object_user.id}"
      
      expect(page).to have_content(short_name)
      expect(page).not_to have_content(full_name)
    end
  end

  describe 'when user' do
    let(:membership) { create(:membership, league: league) }
    let(:user) { membership.user }
    
    before { login_as(user, scope: :user) }

    describe 'is not in same league only sees short name on user_stats#show' do
      let(:league) { create(:league) }
      
      it 'only shows short name on user_stats#show' do
        visit "/user-stats/#{object_user.id}"

        expect(page).to have_content(short_name)
        expect(page).not_to have_content(full_name)
      end
    end

    describe 'is a member on the same league sees full name on user_stats#show' do
      let(:league) { object_league }

      it 'shows full name on user_stats#show' do
        visit "/user-stats/#{object_user.id}"

        expect(page).to have_content(full_name)
      end
    end
  end
end