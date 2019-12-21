require 'rails_helper'

describe GamesController, type: :request do
  let(:game) { create(:game, completed: false) }
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
          get_show

          expect(response).to have_http_status(401)
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
          get_new

          expect(response).to have_http_status(401)
        end
      end
    end

    describe 'when visitor' do
      it 'raises Pundit::NotAuthorizedError' do
        get_new

        expect(response).to have_http_status(401)
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
          post_create

          expect(response).to have_http_status(401)
        end
      end
    end

    describe 'when visitor' do
      it 'raises an error' do
        post_create

        expect(response).to have_http_status(401)
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

        describe 'when game is completed' do
          before { game.update(completed: true) }

          it 'raises an error' do
            get_edit

            expect(response).to have_http_status(401)
          end
        end
      end

      describe 'is member' do
        let(:role) { 0 }

        before { sign_in(user) }

        it 'raises an error' do
          get_edit

          expect(response).to have_http_status(401)
        end
      end
    end

    describe 'when visitor' do
      it 'raises Pundit::NotAuthorizedError' do
        get_edit

        expect(response).to have_http_status(401)
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
          patch_update

          expect(response).to have_http_status(401)
        end
      end
    end

    describe 'when visitor' do
      it 'raises an error' do
        patch_update

        expect(response).to have_http_status(401)
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
          delete_destroy

          expect(response).to have_http_status(401)
        end
      end
    end

    describe 'when visitor' do
      it 'raises an error' do
        delete_destroy

        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST#complete' do
    subject(:post_complete) { post complete_game_path(game); game.reload }

    let(:role) { 1 }

    before { sign_in(user) }

    describe 'with more than 1 finished players' do
      before { create_list(:player, 2, game: game) }

      it 'completes a game' do
        expect {
          post_complete
        }.to change { game.completed }
      end
    end

    describe 'with no finished players' do
      it 'does not complete the game' do
        expect {
          post_complete
        }.not_to change { game.completed }
      end
    end

    describe 'with rebuyers remaining' do
      before do
        create_list(:player, 2, game: game)
        create(:player, game: game, additional_expense: 1, finishing_order: nil, score: nil, finishing_place: nil)
      end

      it 'does not complete the game' do
        expect {
          post_complete
        }.not_to change { game.completed }
      end
    end
  end

  describe 'POST#uncomplete' do
    subject(:post_uncomplete) { post uncomplete_game_path(game); game.reload }

    let(:role) { 1 }

    before do
      game.update(completed: true)
      sign_in(user)
    end

    it 'uncompletes a game' do
      expect {
        post_uncomplete
      }.to change { game.completed }
    end
  end
end
