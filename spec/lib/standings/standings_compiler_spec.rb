require 'rails_helper'

describe Standings::StandingsCompiler do
  let(:limit) { 99 }
  subject { described_class.standings(object, limit) }

  describe "when the object is a league"

  describe "when the object is a season" do
    let(:game) { create(:game_with_players) }
    let(:object) { game.season }
    let(:standings) { subject }

    describe "when the season's scoring system is by points" do
      before { object.points! }

      it "returns players in descending order by points" do
        expect(standings.first.cumulative_score).to be > standings.last.cumulative_score
      end
    end

    describe "when the season's scoring system is by net earnings" do
      let(:first_place) { game.players.find_by(finishing_place: 1) }
      let(:second_place) { game.players.find_by(finishing_place: 2) }

      before do
        first_place.update(additional_expense: 130)
        GameCompleter.new(game, 'complete').save
        first_place.update(score: 100)
        first_place.reload; second_place.reload
        object.net_earnings!
      end

      let(:first_place_index) { standings.pluck(:user_id).index(first_place.user_id) }
      let(:second_place_index) { standings.pluck(:user_id).index(second_place.user_id) }
      
      it do
        expect(first_place_index).to be > second_place_index
      end
    end
  end
end