require 'rails_helper'

describe 'Season has standings', type: :feature do
  let(:league) { create(:league, :public_league) }
  let(:season) { league.active_season }

  describe 'season has one game' do
    let(:game) { create(:game_with_players, season: season) }
    let!(:first) { game.players.sort_by(&:score).last.decorate }
    let!(:last) { game.players.sort_by(&:score).first.decorate }

    it 'shows the players in the correct order' do
      visit season_path(season)

      within('.season-show__overview-standings') do
        within('tr.standing.one') do
          expect(page).to have_content(first.user_display_name)
        end

        within('tr.standing.five') do
          expect(page).to have_content(last.user_display_name)
        end
      end
    end
  end

  describe 'season has more than one game' do
    let(:games) { create_list(:game, 2, season: season, completed: false) }
    let(:users) { create_list(:user, 3) }
    let!(:player_1) { create(:player, game: games.first, user: users.first, finishing_order: 2).decorate }
    let!(:player_2) { create(:player, game: games.first, user: users.second, finishing_order: 1).decorate }

    let!(:player_3) { create(:player, game: games.last, user: users.last, finishing_order: 3).decorate }
    let!(:player_4) { create(:player, game: games.last, user: users.second, finishing_order: 2) }
    let!(:player_5) { create(:player, game: games.last, user: users.first, finishing_order: 1) }
    

    before do
      games.first.update(buy_in: 1500)
      games.last.update(buy_in: 15)
      games.each do |game|
        GameCompleter.new(game, 'complete').save
      end
    end
    
    it 'shows the players in the correct order' do
      visit season_path(season) 

      within('.season-show__overview-standings') do
        within('tr.standing.one') do
          expect(page).to have_content(player_1.user_display_name)
        end
        within('tr.standing.two') do
          expect(page).to have_content(player_2.user_display_name)
        end
        within('tr.standing.three') do
          expect(page).to have_content(player_3.user_display_name)
        end
      end
    end
  end

  describe 'season has no games' do
    it 'shows a no games available message'do
      visit season_path(season)

      within('.season-show__overview-standings') do
        expect(page).to have_content('No games available for standings just yet.')
      end
    end
  end
end
