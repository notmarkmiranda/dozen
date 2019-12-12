require 'rails_helper'

describe Season, type: :model do
  describe 'validations'

  describe 'relationships' do
    it { should belong_to :league }
    it { should have_many :games }
  end

  describe 'methods' do
    let(:season) { create(:season) }

    describe '#activate!' do
      subject(:activate_bang) { season.activate! } 

      before { season.update(active_season: false) }

      it 'updates the active attribute to true' do
        expect {activate_bang }.to change { season.active_season }
      end
    end

    describe '#activate_and_uncomplete!' do
      subject(:activate_and_uncomplete_bang) { season.activate_and_uncomplete! }

      it 'changes active_season and completed attributes' do
        season.update(active_season: false, completed: true)

        expect { 
          activate_and_uncomplete_bang 
        }.to change { season.active_season }
          .and change { season.completed }
      end
    end

    describe '#completed!' do
      subject(:completed_bang) { season.completed! }

      before { season.update(completed: false) }

      it 'changes completed to true' do
        expect { completed_bang }.to change { season.completed }
      end
    end

    describe '#count!' do
      subject(:count_bang) { season.count! }

      before { season.update(count_in_standings: false) }

      it 'updates count_in_standings attribute to true' do
        expect { count_bang }.to change { season.count_in_standings }
      end
    end

    describe '#deactivate!' do
      subject(:deactivate_bang) { season.deactivate! }

      before { season.update(active_season: true) }

      it 'updates active attribute to false' do
        expect { deactivate_bang }.to change { season.active_season }
      end
    end

    describe '#deactivate_and_complete!' do
      subject(:deactivate_and_complete_bang) { season.deactivate_and_complete! }

      it 'changes active_season and completed attributes' do
        season.update(active_season: true, completed: false)

        expect { 
          deactivate_and_complete_bang 
        }.to change { season.active_season }
          .and change { season.completed }
      end

    end

    describe '#games_count' do
      subject(:season_games_count) { season.games_count }
      
      it 'returns zero for no games' do
        expect(season_games_count).to eq(0)
      end

      it 'returns two for two games' do
        create_list(:game, 2, season: season)

        expect(season_games_count).to eq(2)
      end
    end

    describe '#not_completed?' do
      subject(:not_completed?) { season.not_completed? }

      it 'returns true' do
        season.update(completed: false)

        expect(not_completed?).to be true
      end

      it 'returns false' do
        season.update(completed: true)

        expect(not_completed?).to be false
      end
    end

    describe '#number_in_order' do
      subject(:number_in_order) { season.number_in_order }

      before { create(:season, league: season.league) }

      it 'returns the number of season' do
        expect(number_in_order).to eq(2)  
      end
    end

    describe '#uncompleted!' do
      subject(:uncompleted_bang) { season.uncompleted! }

      before { season.update(completed: true) }

      it 'changes completed to false' do
        expect { uncompleted_bang }.to change { season.completed }
      end
    end

    describe '#uncount!' do
      subject(:uncount_bang) { season.uncount! }

      before { season.update(count_in_standings: true) }

      it 'updates count_in_standings attribute to true' do
        expect { uncount_bang }.to change { season.count_in_standings }
      end
    end

    describe 'self#any_active?' do
      subject(:any_active?) { Season.any_active? }

      before { create(:season) }

      it 'returns true' do
        expect(any_active?).to be_truthy
      end

      it 'returns false' do
        Season.update_all(active_season: false)

        expect(any_active?).to be_falsy
      end
    end

    describe 'self#deactivate_all!' do
      let!(:seasons) { create_list(:season, 2, league: season.league, active_season: true) }

      subject(:deactivate_all_bang) { Season.deactivate_all! }

      it 'deactivates all seasons' do
        deactivate_all_bang

        expect(Season.all.pluck(:active_season)[0]).to eq(false)
      end
    end
  end
end
