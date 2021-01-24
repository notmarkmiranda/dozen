require 'rails_helper'

describe 'Visitor can click menu', type: :feature, js: true do
  it 'attempt to click the menu' do
    visit root_path
    sleep(10)
    # Resize to cause bootstrap to show the menu
    page.driver.browser.manage.window.resize_to(50,800)
    sleep(10)
    # The page should not show the menu until we click the menu toggler
    expect(page).to have_no_css '.navbar-collapse'
    sleep(10)
    # Click the menu toggler
    page.find(:xpath, "//button[@class='navbar-toggler']").click
    sleep(10)
    # Now the page should show the navbar contents
    expect(page).to have_css '.navbar-collapse'
  end
end
