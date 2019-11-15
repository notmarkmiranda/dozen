require 'rails_helper'

describe Season, type: :model do
  describe 'validations'
  
  describe 'relationships' do
    it { should belong_to :league }
  end
  
  describe 'methods' do
    describe '#deactivate!' do
      let(:season) { create(:season, active_season: true) }
      
      subject(:deactivate_bang) { season.deactivate! }
      
      it 'updates active attribute to false' do
        expect { deactivate_bang }.to change { season.active_season }
      end
    end
  end
end
