require "rails_helper"

describe "update payouts for mike's dumb math" do
  let(:game) { create(:game, buy_in: 15) }
  let(:league) { game.season.league }
  
  before do
    5.times { |n| create(:player, game: game, finishing_place: n + 1) }
    Dozen::Application.load_tasks
    Rake::Task.define_task(:environment)
    ENV['league_id'] = league.id
    ::GameCompleter.new(game, "complete").save
  end
  
  let(:first_place_player) { game.players.find_by(finishing_place: 1) }
  
  it "should update payouts based on mike's dumb math" do
    expect(first_place_player.payout).to eq(37.5)
    Rake::Task["update_payouts_for_mikes_dumb_math"].invoke

    first_place_player.reload
    expect(first_place_player.payout).to eq(40)
  end
end