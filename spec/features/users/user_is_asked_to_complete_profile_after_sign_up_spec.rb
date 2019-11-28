require 'rails_helper'

describe 'User is asked to complete profile after sign up', type: :feature do
  it 'redirects user to complete profile page' do
    visit new_user_registration_path

    fill_in 'E-Mail Address', with: Faker::Internet.email
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'

    expect(current_path).to eq user_complete_profile_path

    fill_in 'First name', with: Faker::Name.first_name
    fill_in 'Last name', with: Faker::Name.last_name
    click_button 'Complete profile'

    expect(current_path).to eq dashboard_path
    expect(page).to have_content('Leagues')
  end
end
