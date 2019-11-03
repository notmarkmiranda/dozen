require 'rails_helper'

describe 'Visitor can log in', type: :feature do
  let(:password) { "password" }
  before do
    @user = create(:user, password: password)
  end
  
  it 'redirected to dashboard path' do
    visit new_user_session_path
    
    fill_in "Email", with: @user.email
    fill_in "Password", with: password
    click_button "Log in"
    
    expect(current_path).to eq(dashboard_path)
  end
end