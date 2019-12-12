require 'rails_helper'

describe 'User can view active season', type: :feature do
  let(:membership) { create(:membership, role: role) }
  let(:league) { membership.league }
  let(:user) { membership.user }
  let(:season) { league.active_season }

  before { league.update(public_league: public_league) }

  describe 'when league is public' do
    let(:public_league) { true }

    describe 'when user' do
      before { login_as(user, scope: :user) }

      describe 'is admin' do
        let(:role) { 1 }

        it 'navigates to season_path' do
          visit league_path(league)
          click_link "Active season"

          expect(current_path).to eq(season_path(season))
        end
      end

      describe 'is member' do
        let(:role) { 0 }

        it 'navigates to season_path' do
          visit league_path(league)
          click_link "Active season"

          expect(current_path).to eq(season_path(season))
        end
      end

      describe 'is neither admin or member' do
        let(:role) { 1 }
        let(:new_user) { create(:user) }

        before { login_as(user, scope: :user) }

        it 'navigates to season_path' do
          visit league_path(league)
          click_link "Active season"

          expect(current_path).to eq(season_path(season))
        end
      end
    end

    describe 'when visitor' do
      let(:role) { 0 }

      it 'navigates to season path' do
        visit league_path(league)
        click_link "Active season"

        expect(current_path).to eq(season_path(season))
      end
    end
  end

  describe 'when league is private' do
    let(:public_league) { false }

    describe 'when user' do
      before { login_as(user, scope: :user) }

      describe 'is member' do
        let(:role) { 0 }

        it 'navigates to season_path' do
          visit league_path(league)
          click_link "Active season"

          expect(current_path).to eq(season_path(season))
        end
      end

      describe 'is admin' do
        let(:role) { 1 }

        it 'navigates to season_path' do
          visit league_path(league)
          click_link "Active season"

          expect(current_path).to eq(season_path(season))
        end
      end

    end
  end
end
