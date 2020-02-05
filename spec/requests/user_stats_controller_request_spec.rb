require 'rails_helper'

describe UserStatsController, type: :request do
  let(:membership) { create(:membership, role: role) }
  let(:user) { membership.user }

  describe 'GET#show' do
    subject(:get_show) { get user_stats_path(id: stat_user.id) }

    let(:stat_membership) { create(:membership, league: league) }
    let(:stat_user) { stat_membership.user }

    describe 'with logged-in user' do
      before { sign_in(user) }

      describe 'that is a member or admin on the same league' do
        let(:league) { membership.league }

        describe 'as an admin' do
          let(:role) { 1 }

          
          it 'has 200 status' do
            get_show
            
            expect(response).to have_http_status(200)
          end
        end

        describe 'when the logged-in user is a member' do
          let(:role) { 0 }

          it 'has 200 status' do
            get_show

            expect(response).to have_http_status(200)
          end
        end
      end

      describe 'that is a member or admin of another league' do
        let(:league) { create(:league) }

        describe 'as an admin' do
          let(:role) { 1 }

          it 'has a 200 status' do
            get_show

            expect(response).to have_http_status(200)
          end
        end

        describe 'as a member' do
          let(:role) { 0 } 

          it 'has a 200 status' do
            get_show

            expect(response).to have_http_status(200)
          end
        end
      end
    end

    describe 'with a visitor' do
      let(:league) { membership.league }
      let(:role) { 1 }

      it 'has a 200 status' do
        get_show

        expect(response).to have_http_status(200)
      end
    end
  end
end
