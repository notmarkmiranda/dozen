require 'rails_helper'

describe SeasonsController, type: :request do
  let!(:league) { create(:league) }
  let(:season) { league.seasons.first }


  let(:membership) { create(:membership, league: league, role: role) }
  let(:user) { membership.user }

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
          get_show

          expect(response).to have_http_status(401)
        end
      end
    end
  end

  describe 'POST#create' do
    let(:season_params) { { season: { league_id: league.id } } }
    subject(:post_create) { post seasons_path, params: season_params }

    before { login_as(user) }

    describe 'league without other active seasons' do
      let(:role) { 1 }
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
      let(:role) { 1 }

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

  describe 'DELETE#destroy' do
    let(:role) { 1 }
    subject(:delete_destroy) { delete season_path(season) }

    before { sign_in(user) }

    it 'changes season count' do
      expect {
        delete_destroy
      }.to change(Season, :count).by(-1)
    end

    it 'has 302 status' do
      delete_destroy

      expect(response).to have_http_status(302)
    end
  end

  describe 'POST#complete' do
    let(:role) { 1 }
    subject(:post_complete) { post complete_season_path(season) }

    before do
      season.activate_and_uncomplete!
      login_as(user)
    end

    it 'should change active_season and completed' do
      expect {
        post_complete; season.reload
      }.to change { season.active_season }
      .and change { season.completed }
    end
  end

  describe 'GET#confirm' do
    let(:role) { 1 }
    subject(:get_confirm) { get confirm_season_path(season) }

    before { login_as(user) }

    it 'has 200 status' do
      get_confirm

      expect(response).to have_http_status(200)
    end
  end

  describe 'POST#count' do
    let(:role) { 1 }

    subject(:post_count) { post count_season_path(season) }

    before { login_as(user) }

    describe 'when count_in_standings is false' do
      before { season.uncount! }

      it 'changes count_in_standings to true' do
        expect {
          post_count; season.reload
        }.to change{ season.count_in_standings }.to(true)
      end

      it 'has 302 status' do
        post_count

        expect(response).to have_http_status(302)
      end
    end

    describe 'when count_in_standings is true' do
      before { season.count! }

      it 'does not change count_in_standings from true' do
        expect {
          post_count; season.reload
        }.not_to change { season.count_in_standings }.from(true)
      end

      it 'has 302 status' do
        post_count

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'POST#deactivate' do
    let(:role) { 1 }

    subject(:post_deactivate) { post deactivate_season_path(season) }

    before { login_as(user) }

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
    let(:role) { 1 }

    subject(:post_leave) { post leave_season_path(season) }

    before { login_as(user) }

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

  describe 'POST#uncomplete' do
    let(:role) { 1 }

    subject(:post_uncomplete) { post uncomplete_season_path(season) }

    before do
      season.deactivate_and_complete!
      login_as(user)
    end

    it 'uncompletes and activates season' do
      expect {
        post_uncomplete; season.reload
      }.to change { season.active_season }
      .and change { season.completed }
    end

    it 'has 302 status' do
      post_uncomplete

      expect(response).to have_http_status(302)
    end
  end

  describe 'POST#uncount' do
    let(:role) { 1 }

    subject(:post_uncount) { post uncount_season_path(season) }

    before { login_as(user) }

    describe 'when count_in_standings is false' do
      before { season.uncount! }

      it 'does not changes count_in_standings from false' do
        expect {
          post_uncount; season.reload
        }.not_to change{ season.count_in_standings }.from(false)
      end

      it 'has 302 status' do
        post_uncount

        expect(response).to have_http_status(302)
      end
    end

    describe 'when count_in_standings is true' do
      before { season.count! }

      it 'changes count_in_standings to false' do
        expect {
          post_uncount; season.reload
        }.to change { season.count_in_standings }.to(false)
      end

      it 'has 302 status' do
        post_uncount

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'PUT#update_settings' do
    let(:role) { 1 }

    subject(:put_update_settings) { put update_settings_season_path(season) }
  end

  describe 'PUT#scoring_system' do
    let(:role) { 1 }
    subject(:put_scoring_system) { put scoring_system_season_path(season), params: {:season => {scoring_system: "net_earnings"}} }
    before do
      season.points!
      sign_in(user)
    end

    it "toggles scoring system to net earnings" do
      expect { put_scoring_system }.to change { season.reload; season.scoring_system }

    end
  end
end
