require 'rails_helper'

describe 'League has standings', type: :feature do
  let(:league) { create(:league, :public_league) }
  let(:season) { league.active_season }

  describe 'League has one season with a game' do
    let(:game) { create(:game_with_players, season: season) }
    let!(:first) { game.players.sort_by(&:score).last.decorate }
    let!(:last) { game.players.sort_by(&:score).first.decorate }

    it 'shows the players in the correct order' do
      visit league_path(league)

      within('.league-show__overview-standings') do
        within('tr.standing.one') do
          expect(page).to have_content(first.user_full_name)
        end

        within('tr.standing.five') do
          expect(page).to have_content(last.user_full_name)
        end
      end
    end
  end

  describe 'League has more than one season with at least one game each' do
    let(:game) { create(:game, season: season, completed: false) }
    let(:other_season) { create(:season, league: league) }
    let(:other_game) { create(:game, season: other_season, completed: false) }

    let(:users) { create_list(:user, 3) }
    let!(:player_1) { create(:player, game: game, user: users.first, finishing_order: 2).decorate }
    let!(:player_2) { create(:player, game: game, user: users.second, finishing_order: 1).decorate }

    let!(:player_3) { create(:player, game: other_game, user: users.last, finishing_order: 3).decorate }
    let!(:player_4) { create(:player, game: other_game, user: users.second, finishing_order: 2) }
    let!(:player_5) { create(:player, game: other_game, user: users.first, finishing_order: 1) }
    

    before do
      game.update(buy_in: 1500)
      other_game.update(buy_in: 15)
      [game, other_game].each do |game|
        GameCompleter.new(game, 'complete').save
      end
    end
    
    it 'shows the players in the correct order' do
      visit league_path(league)

      within('.league-show__overview-standings') do
        within('tr.standing.one') do
          expect(page).to have_content(player_1.user_full_name)
        end
        within('tr.standing.two') do
          expect(page).to have_content(player_2.user_full_name)
        end
        within('tr.standing.three') do
          expect(page).to have_content(player_3.user_full_name)
        end
      end
    end
  end

  describe 'League has one season with no games' do
    it 'shows a no games available message' do
      visit league_path(league)

      within('.league-show__overview-standings') do
        expect(page).to have_content('No games available for standings just yet.')
      end
    end
  end
  
  describe 'League has more than one season and one is not counted' do
    let(:game) { create(:game, season: season, completed: false) }
    let(:other_season) { create(:season, league: league, count_in_standings: false) }
    let(:other_game) { create(:game, season: other_season, completed: false) }

    let(:users) { create_list(:user, 3) }
    let!(:player_1) { create(:player, game: game, user: users.first, finishing_order: 2).decorate }
    let!(:player_2) { create(:player, game: game, user: users.second, finishing_order: 1).decorate }

    let!(:player_3) { create(:player, game: other_game, user: users.last, finishing_order: 3).decorate }
    let!(:player_4) { create(:player, game: other_game, user: users.second, finishing_order: 2) }
    let!(:player_5) { create(:player, game: other_game, user: users.first, finishing_order: 1) }
    

    before do
      game.update(buy_in: 15)
      other_game.update(buy_in: 1500)
      [game, other_game].each do |game|
        GameCompleter.new(game, 'complete').save
      end
    end
    
    it 'shows the players in the correct order' do
      visit league_path(league)

      within('.league-show__overview-standings') do
        within('tr.standing.one') do
          expect(page).to have_content(player_1.user_full_name)
        end
        within('tr.standing.two') do
          expect(page).to have_content(player_2.user_full_name)
        end
        expect(page).not_to have_content(player_3.user_full_name)
      end
    end
  end
end