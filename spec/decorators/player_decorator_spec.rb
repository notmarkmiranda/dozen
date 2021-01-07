require 'rails_helper'

describe PlayerDecorator, type: :decorator do
  let(:decorated_player) { create(:player).decorate }
  let(:season) { decorated_player.player.game.season } 

  describe "#payout_by_season" do
    subject(:show_payout) { decorated_player.payout_by_season(season) }
    
    before do
      allow(decorated_player.player).to receive(:net_earnings_by_season).with(season).and_return(payout)
    end

    describe "for zero amounts" do
      let(:payout) { 0 }
      
      it "returns $0" do
        expect(show_payout).to eq("$0.00")
      end
    end

    describe "for negative amounts" do
      let(:payout) { -154.75 }
      
      it  "returns -$154.75" do
        expect(show_payout).to eq("-$154.75")
      end
    end
    
    describe "for positive amounts" do
      let(:payout) { 20 }
      
      it "returns $20" do
        expect(show_payout).to eq("$20.00")
      end
    end
  end
end
