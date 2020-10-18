require "rails_helper"

describe "complete_games_by_season" do
  let(:game) { create(:game, buy_in: 10000, completed: true) }
  let!(:first) { create(:player, game: game, finishing_place: 1, payout: 0) }  
  let!(:second) { create(:player, game: game, finishing_place: 2, payout: 0) }  
  let!(:third) { create(:player, game: game, finishing_place: 3, payout: 0) }  

  let(:season) { game.season }

  before do
    Dozen::Application.load_tasks
    Rake::Task.define_task(:environment)
  end

  it "should complete all seasons games and assign payouts" do
    ENV['season_id'] = season.id
    Rake::Task["complete_games_by_season"].invoke
    [first, second, third].each(&:reload)
    expect(first.payout).not_to eq(0)
  end
end