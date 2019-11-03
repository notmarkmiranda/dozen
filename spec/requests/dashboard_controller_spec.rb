require 'rails_helper'

describe DashboardController, type: :request do
  describe 'GET#show' do
    subject(:get_show) { get dashboard_path }
    
    describe 'signed-in user' do
      let(:user) { create(:user) }
      
      before { sign_in(user) }
      
      it 'has status 200' do
        get_show
        
        expect(response).to have_http_status(200)
      end
    end
    
    describe 'visitor' do
      it 'has status 302' do
        get_show
        
        expect(response).to have_http_status(302)
      end
    end
  end
end