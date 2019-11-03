require 'rails_helper'

describe LeaguesController, type: :request do
  let(:user) { create(:user) }
  
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
    let(:league_params) { { league: attributes_for(:league) } }
    
    subject(:post_create) { post leagues_path, params: league_params }
    
    describe 'signed-in user' do
      before do
        sign_in(user)
      end
      
      it 'has status 302' do
        post_create
        
        expect(response).to have_http_status(302)
      end
      
      it 'changes league count' do
        expect { 
          post_create 
        }.to change(League, :count).by(1)
        .and change(Membership, :count).by(1)
      end
    end
    
    describe 'visitor' do
      it 'has status 302' do
        post_create
        
        expect(response).to have_http_status(302)
      end
      
      it 'not change league count' do
        expect {
          post_create
        }.to change(League, :count).by(0)
        .and change(Membership, :count).by(0)
      end
    end
  end
end