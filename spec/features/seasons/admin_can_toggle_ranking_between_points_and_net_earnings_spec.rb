require 'rails_helper'

describe "The season page" do 

  let(:league) { create(:league) }
  let!(:season) { league.seasons.first }
  let(:game) { create(:game, season: season) }
  let!(:player_1) { create(:player, game: game, finishing_place: 2, score: 15 ) }
  let!(:player_2) { create(:player, game: game, finishing_place: 1, score: 25 ) }
  let!(:player_3) { create(:player, game: game, finishing_place: 3, score: 10 ) }
  
  let(:membership) { create(:membership, league: league, role: role) }
  let(:user) { membership.user }
  
  
  describe "(happy path)" do
    let(:role) { 1 }
    subject(:put_scoring_system) { put scoring_system_season_path(season), params: {:season => {scoring_system: "net_earnings"}} }
    before do
      season.points!
      login_as(user, scope: :user)
    end
    
    it "allows admin to toggle between points and net earnings for a season" do
      binding.pry
      # make sure season is set to points
      expect(season.scoring_system).to eq("points")
      # visit seasons page
      visit season_path(season)

      # expect page to list season points && current scoring button value to be points
      
      # toggle scoring scoring button to "net earnings"
      click_link "Net Earnings"
      expect(season.scoring_system).to eq("net_earnings")
      # expect page to list net earnings for season && current scoring button value to be net_earnings 
    end

    # test with net earnings being default value
  end

  describe "(sad path)" do
    # can season page exist without data?
  end

end