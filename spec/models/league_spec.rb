require 'rails_helper'

describe League, type: :model do
  describe 'validations' do
    it { should validate_uniqueness_of :name }
  end
  
  describe 'relationships' do 
    it { should have_many :memberships }
    it { should have_many :seasons }
  end
  
  describe 'methods' do
    let(:league) { create(:league) }
    
    describe '#active_season' do
      subject(:active_season) { league.active_season }
      
      before { league.seasons.first.deactivate! }
      
      let!(:new_season) { create(:season, league: league, active_season: true) }
      
      it 'returns the active season' do
        expect(active_season).to eq(new_season)
      end
    end
  end
end
