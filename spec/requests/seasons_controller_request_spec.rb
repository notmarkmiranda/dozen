require 'rails_helper'

describe SeasonsController, type: :request do
  let!(:league) { create(:league) }
  let(:season) { league.seasons.first }


  describe 'GET#show' do
    before { league.update(public_league: public_league) }

    subject(:get_show) { get season_path(season) }

    describe 'when the league is public' do
      let(:public_league) { true }

      it 'has 200 status' do
        get_show

        expect(response).to have_http_status(200)
      end
    end

    describe 'when the league is private' do
      let(:public_league) { false }

      describe 'when user' do
        let(:membership) { create(:membership, league: league, role: role) }
        let(:user) { membership.user }

        before { sign_in(user) }

        describe 'is admin' do
          let(:role) { 1 }

          it 'has 200 status' do
            get_show

            expect(response).to have_http_status(200)
          end
        end

        describe 'is member' do
          let(:role) { 0 }

          it 'has 200 status' do
            get_show

            expect(response).to have_http_status(200)
          end
        end
      end

      describe 'when visitor' do
        let(:role) { 0 }

        it 'raises Pundit::NotAuthorizedError' do
            expect {
              get_show
            }.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
  end

  describe 'POST#create' do
    let(:season_params) { { season: { league_id: league.id } } }
    subject(:post_create) { post seasons_path, params: season_params }

    describe 'league without other active seasons' do
      before { league.seasons.deactivate_all! }

      describe 'happy path, season gets created' do
        it 'should create a new season' do
          expect { post_create }.to change(Season, :count).by(1)
        end

        it 'should not call #confirmation method' do
          post_create

          expect(controller).not_to receive(:confirmation)
        end

        it 'has a 302 status' do
          post_create

          expect(response).to have_http_status(302)
        end
      end

      describe 'sad path, season does not get created' # i don't know how this would happen? maybe no league, but that would throw an error elsewhere?
    end

    describe 'league with other active season' do
      before { league.seasons.last.activate! }

      it 'has an active season' do
        expect(league.seasons.any_active?).to be_truthy
      end

      it 'should create a new season' do
        expect { post_create }.not_to change(Season, :count)
      end

      it 'should call #create on league#seasons' do
        post_create

        expect(league.seasons).not_to receive(:create)
      end

      it 'has a 302 status' do
        post_create

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'GET#confirm' do
    subject(:get_confirm) { get season_confirm_path(season) }

    it 'has 200 status' do
      get_confirm

      expect(response).to have_http_status(200)
    end
  end

  describe 'POST#deactivate' do
    subject(:post_deactivate) { post season_deactivate_path(season) }

    it 'creates a new season' do
      expect { post_deactivate }.to change(Season, :count).by(1)
    end

    it 'deactivates other seasons' do
      expect {
        post_deactivate; season.reload
      }.to change { season.active_season }
    end

    it 'has 302 status' do
      post_deactivate

      expect(response).to have_http_status(302)
    end
  end

  describe 'POST#leave' do
    subject(:post_leave) { post season_leave_path(season) }

    it 'creates a new season' do
      expect { post_leave }.to change(Season, :count).by(1)
    end

    it 'does not deactivate other season' do
      expect {
        post_leave; season.reload
      }.not_to change { season.active_season }
    end

    it 'has 302 status' do
      post_leave

      expect(response).to have_http_status(302)
    end
  end
end
