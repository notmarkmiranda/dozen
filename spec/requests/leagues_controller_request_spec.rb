require 'rails_helper'

describe LeaguesController, type: :request do
  let(:user) { create(:user) }

  describe 'GET#show' do
    let(:league) { create(:league, public_league: public_league) }

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

      before do
        sign_in(user)
      end

      describe 'member or admin on league' do
        before do
          create(:membership, league: league, user: user, role: role)
        end

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

  describe 'GET#edit'
  describe 'PATCH#update'
end
