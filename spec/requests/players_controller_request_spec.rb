require 'rails_helper'

describe PlayersController, type: :request do
  let(:game) { create(:game) }
  let!(:player) { create(:player, game: game) }
  let(:league) { game.season_league }
  let(:membership) { create(:membership, league: league, role: 1) }
  let(:user) { membership.user }

  before { sign_in(user) }

  describe 'POST#create' do
    subject(:post_create) { post players_path, params: player_params }

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

      it 'creates a new player' do
        expect {
          post_create
        }.to change(Player, :count).by(1)

        expect(Player.last.finishing_order).not_to be_nil
      end
    end

    describe 'when commit is for an additional expense' do
      let(:additional_expense) { 1 }
      let(:commit) { 'Add Rebuy or Add-on Only' }

      it 'creates a new player' do
        expect {
          post_create
        }.to change(Player, :count).by(1)

        expect(Player.last.finishing_order).to be_nil
        expect(Player.last.additional_expense).to eq(1)
      end
    end
  end

  describe 'GET#edit' do
    subject(:get_edit) { get edit_player_path(player) }

    it 'has 200 status' do
      get_edit
      
      expect(response).to have_http_status(200)
    end
  end

  describe 'PATCH#update' do
    subject(:patch_update) { patch player_path(player), params: player_params }

    let(:player_params) do
      {
        commit: 'Update player',
        player: {
          additional_expense: 923
        }
      }
    end

    it 'updates a player' do
      expect {
        patch_update; player.reload
      }.to change { player.additional_expense }
    end
  end

  describe 'DELETE#destroy' do
    subject(:delete_destroy) { delete player_path(player), params: { commit: 'Delete player' } }

    it 'deletes a player' do
      expect {
        delete_destroy; game.reload
      }.to change(Player, :count).by(-1)
    end
  end
end
