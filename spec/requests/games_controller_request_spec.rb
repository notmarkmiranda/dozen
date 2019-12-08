require 'rails_helper'

describe GamesController, type: :request do
  let(:game) { create(:game) }
  let(:season) { game.season }
  let(:league) { season.league }
  let(:membership) { create(:membership, league: league, role: role) }
  let(:user) { membership.user }
  let(:role) { 0 }

  describe 'GET#show' do
    before { league.update(public_league: public_league) }

    subject(:get_show) { get game_path(game) }

    describe 'when the league is public' do
      let(:public_league) { true }

      it 'has 200 status' do
        get_show

        expect(response).to have_http_status(200)
      end
    end

    describe 'when the league is not public' do
      let(:public_league) { false }

      describe 'when user is a member or admin' do
        before { sign_in(user) }

        it 'has 200 status' do
          get_show

          expect(response).to have_http_status(200)
        end
      end

      describe 'when visitor' do
        it 'raises a Pundit::NotAuthorizedError' do
          expect {
            get_show
          }.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
  end

  describe 'GET#new' do
    subject(:get_new) { get new_game_path, params: { game: { season_id: season.id } } }

    describe 'when user' do
      describe 'is admin' do
        let(:role) { 1 }

        before { sign_in(user) }

        it 'has 200 status' do
          get_new

          expect(response).to have_http_status(200)
        end
      end

      describe 'is member' do
        let(:role) { 0 }

        before { sign_in(user) }

        it 'raises an error' do
          expect {
            get_new
          }.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end

    describe 'when visitor' do
      it 'raises Pundit::NotAuthorizedError' do
        expect {
          get_new
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end

  describe 'POST#create' do
    let(:game_params) { { game: attributes_for(:game, season_id: season.id) } }

    subject(:post_create) { post games_path, params: game_params }

    describe 'when user' do
      before { sign_in(user) }

      describe 'is admin' do
        let(:role) { 1 }

        it 'creates a new game' do
          expect {
            post_create
          }.to change(Game, :count).by(1)
        end

        it 'has 302 status' do
          post_create

          expect(response).to have_http_status(302)
        end
      end

      describe 'is member' do
        let(:role) { 0 }

        it 'raises an error' do
          expect {
            post_create
          }.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end

    describe 'when visitor' do
      it 'raises an error' do
        expect {
          post_create
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end

  describe 'GET#edit' do
    subject(:get_edit) { get edit_game_path(game) }

    describe 'when user' do
      describe 'is admin' do
        let(:role) { 1 }

        before { sign_in(user) }

        it 'has 200 status' do
          get_edit

          expect(response).to have_http_status(200)
        end
      end

      describe 'is member' do
        let(:role) { 0 }

        before { sign_in(user) }

        it 'raises an error' do
          expect {
            get_edit
          }.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end

    describe 'when visitor' do
      it 'raises Pundit::NotAuthorizedError' do
        expect {
          get_edit
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end

  describe 'PATCH#update' do
    let(:game_params) { { game: { players: 9 } } }

    subject(:patch_update) { patch game_path(game), params: game_params }

    describe 'when user' do
      before { sign_in(user) }

      describe 'is admin' do
        let(:role) { 1 }

        it 'creates a new game' do
          expect {
            patch_update; game.reload
          }.to change{ game.players }
        end

        it 'has 302 status' do
          patch_update

          expect(response).to have_http_status(302)
        end
      end

      describe 'is member' do
        let(:role) { 0 }

        it 'raises an error' do
          expect {
            patch_update
          }.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end

    describe 'when visitor' do
      it 'raises an error' do
        expect {
          patch_update
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end

  describe 'DELETE#destroy' do
    subject(:delete_destroy) { delete game_path(game) }

    describe 'when user' do
      before { sign_in(user) }

      describe 'is admin' do
        let(:role) { 1 }

        it 'creates a new game' do
          expect {
            delete_destroy
          }.to change(Game, :count).by(-1)
        end

        it 'has 302 status' do
          delete_destroy

          expect(response).to have_http_status(302)
        end
      end

      describe 'is member' do
        let(:role) { 0 }

        it 'raises an error' do
          expect {
            delete_destroy
          }.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end

    describe 'when visitor' do
      it 'raises an error' do
        expect {
          delete_destroy
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end

  pending 'POST#complete'
  
  pending 'POST#uncomplete'
end
