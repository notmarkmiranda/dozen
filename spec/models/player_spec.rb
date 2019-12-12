require 'rails_helper'

describe Player, type: :model do
  describe 'relationships' do
    it { should belong_to :game }
    it { should belong_to :user }
  end

  describe 'validations' do
    before { create(:player) }
    it { should validate_uniqueness_of(:game).scoped_to(:user_id) }
  end

  describe 'methods' do
    let(:player) { create(:player, finishing_place: 1, additional_expense: 0) }

    describe '#additional_expense_commit' do
      subject(:player_additional_expense_commit) { player.additional_expense_commit }

      describe 'returns :delete_player' do
        it 'when additional_expense is zero' do
          player.update(additional_expense: 0)

          expect(player_additional_expense_commit).to eq(:delete_player)
        end

        it 'when additional_expense is nil' do
          player.update(additional_expense: nil)

          expect(player_additional_expense_commit).to eq(:delete_player)
        end
      end

      it 'returns :move_to_rebuyers' do
        player.update(additional_expense: 1)

        expect(player_additional_expense_commit).to eq(:move_to_rebuyers)
      end
    end

    describe '#calculate_score' do
      subject(:player_calculate_score) { player.calculate_score(10, 100); player.reload }

      it 'calculates_score' do
        expect {
          player_calculate_score
        }.to change { player.score }.to(15.8113883008419)
      end
    end
  end
end
