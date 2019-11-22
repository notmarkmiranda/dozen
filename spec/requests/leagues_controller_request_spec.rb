require 'rails_helper'

describe LeaguesController, type: :request do
  let(:user) { create(:user) }
  let(:league) { create(:league, public_league: public_league) }

  describe 'GET#show' do
    subject(:get_show) { get league_path(league) }

    describe 'public league' do
      let(:public_league) { true }

      it 'has status 200' do
        get_show

        expect(response).to have_http_status(200)
      end
    end

    describe 'private league' do
      let(:public_league) { false }

      before { sign_in(user) }

      describe 'member or admin on league' do
        before { create(:membership, league: league, user: user, role: role) }

        describe 'for member' do
          let(:role) { 0 }

          it 'has status 200' do
            get_show

            expect(response).to have_http_status(200)
          end
        end

        describe 'for admin' do
          let(:role) { 1 }

          it 'has status 200' do
            get_show

            expect(response).to have_http_status(200)
          end
        end
      end

      describe 'for non-member / non-admin' do
        it 'raises pundit not authorized error' do
          expect { get_show }.to raise_error(Pundit::NotAuthorizedError)
        end
      end

      describe 'for visitor' do
        before { sign_out(user) }

        it 'raises pundit not authorized error' do
          expect { get_show }.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
  end

  describe 'GET#new' do
    subject(:get_new) { get new_league_path }

    describe 'signed-in user' do

      before do
        sign_in(user)
        get_new
      end

      it 'has status 200' do
        expect(response).to have_http_status(200)
      end
    end

    describe 'visitor' do
      before { get_new }

      it 'has status 302' do
        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'POST#create' do
    let(:league_params) { { league: attributes_for(:league, name: name) } }
    subject(:post_create) { post leagues_path, params: league_params }

    describe 'signed-in user' do
      before { sign_in(user) }

      describe 'successful create' do
        let(:name) { "Super" }
        it 'has status 302' do
          post_create

          expect(response).to have_http_status(302)
        end

        it 'changes league count' do
          expect {
            post_create
          }.to change(League, :count).by(1)
          .and change(Membership, :count).by(1)
          .and change(Season, :count).by(1)
        end
      end

      describe 'unsuccessful create' do
        let(:name) { nil }

        it 'has status 200' do
          post_create

          expect(response).to have_http_status(200)
        end

        it 'does not change league count' do
          expect {
            post_create
          }.to change(League, :count).by(0)
          .and change(Membership, :count).by(0)
          .and change(Season, :count).by(0)
        end
      end
    end

    describe 'visitor' do
      let(:name) { "Super" }
      it 'has status 302' do
        post_create

        expect(response).to have_http_status(302)
      end

      it 'not change league count' do
        expect {
          post_create
        }.to change(League, :count).by(0)
        .and change(Membership, :count).by(0)
        .and change(Season, :count).by(0)
      end
    end
  end

  describe 'GET#edit' do
    let(:public_league) { true }

    subject(:get_edit) { get edit_league_path(league) }

    describe 'logged-in user' do
      let(:user) { create(:membership, role: 1, league: league).user }
      before { sign_in(user) }

      it 'has status 200' do
        get_edit

        expect(response).to have_http_status(200)
      end
    end

    describe 'visitor' do
      it 'raises pundit::NotAuthorizedError' do
        expect {
          get_edit
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end

  describe 'PATCH#update' do
    let(:public_league) { false }
    let(:league_params) { { league: { name: name } } }

    subject(:patch_update) { patch league_path(league), params: league_params }

    describe 'admin on league' do
      let(:admin) { create(:membership, role: 1, league: league).user }

      before { sign_in(admin) }

      describe 'successful update' do
        let(:name) { 'Update Name' }

        it 'updates league' do
          expect {
            patch_update; league.reload
          }.to change { league.name }
        end
      end

      describe 'unsuccessful update' do
        let(:name) { nil }

        it 'does not update league' do
          expect {
            patch_update; league.reload
          }.not_to change { league.name }
        end
      end
    end

    describe 'visitor' do
      let(:name) { 'Super!' }

      it 'raises NotAuthorizedError' do
        expect{
          patch_update
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end

  describe 'DELETE#destroy' do
    let(:public_league) { true }
    let(:membership) { create(:membership, league: league, role: 1) }
    let(:user) { membership.user }

    subject(:delete_destroy) { delete league_path(league) }

    before { sign_in(user) }

    it 'deletes a league' do
      expect {
        delete_destroy
      }.to change(League, :count).by(-1)
    end

    it 'has 302 status' do
      delete_destroy

      expect(response).to have_http_status(302)
    end
  end
end
