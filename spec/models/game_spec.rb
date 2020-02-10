require 'rails_helper'

describe Game, type: :model do
  let(:game) { create(:game) }
  let(:league) { game.season_league}

  describe 'validations' do
    it { should validate_presence_of :buy_in }
  end

  describe 'relationships' do
    it { should belong_to(:season).without_validating_presence }
    it { should belong_to(:league).without_validating_presence }
    it { should have_many :players }
  end

  describe 'methods' do
    describe '#available_players' do
      subject(:game_available_players) { game.available_players }
      let(:memberships) { create_list(:membership, 2, league: league)}
      let(:users) { memberships.map(&:user) }
      # let!(:players) { create_list(:player, 2, game: game, finishing_place: nil, additional_expense: 0, finishing_order: nil) }
      let(:collected_players) { UserDecorator.decorate_collection(users).collect { |u| [u.full_name, u.id] } }
      let(:first_player) { collected_players.first }
      let(:second_player) { collected_players.last }


      it 'does not include a finished player' do
        create(:player, game: game, user: users[0])

        expect(game_available_players).to include(second_player)
        expect(game_available_players).not_to include(first_player)
      end
      
      it 'does not include a rebuyer' do
        create(:player, game: game, user: users[1], additional_expense: 100)

        expect(game_available_players).to include(first_player)
        expect(game_available_players).not_to include(second_player)
      end
    end

    describe '#not_completed?' do
      subject(:game_not_completed?) { game.not_completed? }

      it 'returns true' do
        game.update(completed: false)

        expect(game_not_completed?).to eq(true)
      end

      it 'returns false' do
        game.update(completed: true)

        expect(game_not_completed?).to eq(false)
      end
    end

    describe '#players_except_self' do
      subject(:game_players_except_self) { game.players_except_self(players.last) }

      let(:players) { create_list(:player, 2, game: game) }

      it 'returns players except the player passed in' do
        expect(game_players_except_self).to include(players.first)
        expect(game_players_except_self).not_to include(players.last)
      end
    end

    describe 'shared players' do
      let!(:rebuyer) { create(:player, finishing_order: nil, finishing_place: nil, additional_expense: 1, game: game) }
      let!(:finisher) { create(:player, finishing_order: 1, finishing_place: nil, additional_expense: 1, game: game) }

      describe '#rebuyers' do
        subject(:game_rebuyers) { game.rebuyers }

        it 'returns rebuyers' do
          expect(game_rebuyers).to include(rebuyer)
        end

        it 'does not return finisher' do
          expect(game_rebuyers).not_to include(finisher)
        end
      end

      describe '#finished_players' do
        subject(:game_finished_players) { game.finished_players }

        it 'returns finishers' do
          expect(game_finished_players).to include(finisher)
        end

        it 'does not return rebuyers' do
          expect(game_finished_players).not_to include(rebuyer)
        end
      end
    end
  end
end
