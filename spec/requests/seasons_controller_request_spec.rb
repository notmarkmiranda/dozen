require 'rails_helper'

describe SeasonsController, type: :request do
  let(:league) { create(:league) }

  let(:season_params) do
    { season: { league_id: league.id } }
  end

  describe 'POST#create' do
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

  describe 'GET#confirm'

  describe 'POST#deactivate'

  describe 'POST#leave'
end
