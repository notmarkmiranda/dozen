require 'rails_helper'

describe Game, type: :model do
  let(:game) { create(:game) }

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

      let!(:players) { create_list(:player, 2, game: game, finishing_place: nil, additional_expense: nil, finishing_order: nil) }
      let(:collected_players) { UserDecorator.decorate_collection(players.map(&:user)).collect { |u| [u.full_name, u.id] } }
      let(:first_player) { collected_players.first }
      let(:second_player) { collected_players.last }


      it 'does not include a finished player' do
        players[0].update(finishing_order: 1)

        expect(game_available_players).to include(second_player)
        expect(game_available_players).not_to include(first_player)
      end
      
      it 'does not include a rebuyer' do
        players[1].update(additional_expense: 100)

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

    pending '#rebuyers'

    pending '#finished_players'
  end
end
