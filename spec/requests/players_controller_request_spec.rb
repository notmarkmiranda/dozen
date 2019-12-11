require 'rails_helper'

describe PlayersController, type: :request do
  describe 'POST#create' do
    subject(:post_create) { post players_path, params: player_params }

    let(:game) { create(:game) }
    let(:user) { create(:user) }
    let(:player_params) do 
      {
        commit: commit,
        player: attributes_for(
                  :player,
                  finishing_order: nil,
                  finishing_place: nil,
                  score: nil,
                  additional_expense: additional_expense,
                  game_id: game.id,
                  user_id: user.id
                )
      }
    end

    describe 'when commit is finish player' do
      let(:additional_expense) { 0 }
      let(:commit) { 'Finish player' }

      # TODO: this test should fail because of logins?
      it 'creates a new player' do
        expect {
          post_create
        }.to change(Player, :count).by(1)
      end
    end

    pending 'when commit is for an additional expense'
  end

  pending 'GET#edit'

  pending 'PATCH#update'

  pending 'DELETE#destroy'
end
