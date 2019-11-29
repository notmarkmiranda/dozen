require 'rails_helper'

describe UsersController, type: :request do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'PATCH#update' do
    let(:user_params) { { commit: 'Complete profile', user: { first_name: 'Mark!' } } }

    subject(:patch_update) { patch user_complete_profile_path(user.id), params: user_params }

    it 'updates the user' do
      expect {
        patch_update; user.reload
      }.to change{ user.first_name }
    end
  end

  describe 'GET#complete_profile' do
    subject(:get_complete_profile) { get user_complete_profile_path }

    it 'has 200 status' do
      get_complete_profile

      expect(response).to have_http_status(200)
    end
  end
end
