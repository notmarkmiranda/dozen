require "rails_helper"

describe "A season will rank users by net earnings", type: :feature do
  let(:game) { create(:game, completed: true) }
  let(:season) { game.season }
  let(:league) { season.league }
  let(:memberships) { create_list(:membership, 2, league: league) }
  let(:user1) { memberships[0].user }
  let(:user2) { memberships[1].user }
  let!(:player1) { create(:player, game: game, finishing_place: 2, payout: 100, score: 10).decorate }
  let!(:player2) { create(:player, game: game, finishing_place: 1, payout: 10, score: 100).decorate }

  before do 
    season.update(scoring_system: 1)
    login_as(user1, scope: :user)
  end

  it "ranks users by net earnings" do
    visit season_path(season)

    within("tr.standing.one") do
      expect(page).to have_content(player1.user_full_name)
    end
  end
end