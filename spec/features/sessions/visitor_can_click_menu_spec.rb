require 'rails_helper'

describe 'Visitor can click menu', type: :feature do
  it 'attempt to click the menu' do
    Capybara.default_driver = :selenium

    visit "/"

    # Resize to cause bootstrap to show the menu
    page.driver.browser.manage.window.resize_to(400,200)

    # The page should not show the menu until we click the menu
    expect(page).to have_no_css '.navbar-collapse'

    # Click the menu
    page.find(:xpath, "//button[@class='navbar-toggler']").click

    # Now the page should show the menu
    expect(page).to have_css '.navbar-collapse'
  end
end
