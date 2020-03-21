require 'rails_helper'

describe League, type: :model do
  describe 'validations' do
    it { should validate_uniqueness_of :name }
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many :memberships }
    it { should have_many :seasons }
    it { should have_many(:games).through(:seasons) }
    it_behaves_like 'settable'
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

    describe '#games.in_reverse_date_order' do
      subject { league.games_in_reverse_date_order }
      describe 'with multiple seasons' do
        let!(:first_season) { create(:season, league: league) }
        let!(:second_season) { create(:season, league: league) }
        let!(:first_game) do 
          create(:game, season: first_season, completed: true, date: DateTime.new(2000, 1, 1))
        end
        
        let!(:second_game) do 
          create(:game, season: second_season, completed: true, date: DateTime.new(2010, 2, 3))
        end

        it 'shows the games in the correct order' do
          expect(subject.first).to eq(second_game)
          expect(subject.last).to eq(first_game)
        end
      end
    end
  end
end
