require "rails_helper"

describe "Season has net earnings", type: :feature do
  describe "For a season with a completed game" do
    let(:game) { create(:game_with_players, buy_in: 100) }
    let(:season) { game.season }
    let(:user) { game.players.last.user }

    before do 
      season.net_earnings!
      login_as(user, scope: :user)
    end

    it "shows net earnings on a season show" do
      visit season_path(season)

      expect(page).to have_content("$150.00")
      expect(page).to have_content("$50.00")
      expect(page).to have_content("$0.00")
    end
  end
end