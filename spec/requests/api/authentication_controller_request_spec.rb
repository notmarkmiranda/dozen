require 'rails_helper'

describe Api::AuthenticationController, type: :request do
  let!(:user) { create(:user, password: 'password') }
  describe 'POST#auth_user' do
    subject(:post_auth_user) { post api_auth_user_path, params: params }
    
    describe 'with valid user and password' do
      let(:params) do
        {
          username: user.email,
          password: 'password'  
        }
      end

      before do
        allow(JsonWebToken).to receive(:encode).and_return('abcd')
      end

      let(:expected_return) do
        {
          'auth_token' => 'abcd',
          'user' =>
          {
            'id' => user.id,
            'email' => user.email
          }
        }
      end

      it 'returns a payload' do
        post_auth_user

        body = JSON.parse(response.body)
        expect(body.keys).to match_array %w[auth_token user]
        expect(body).to eq(expected_return)
      end
    end

    describe 'with valid user and invalid password' do
      let(:params) do
        {
          username: user.email,
          password: 'passwordz'  
        }
      end

      it 'returns a payload' do
        post_auth_user

        body = JSON.parse(response.body)
        expect(body).to eq({ 'errors' => ['Invalid Username / Password'] })
      end
    end
  end
end