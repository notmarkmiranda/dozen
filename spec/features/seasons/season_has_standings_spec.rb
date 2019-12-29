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
          expect(page).to have_content(first.user_full_name)
        end
        
        within('tr.standing.five') do
          expect(page).to have_content(last.user_full_name)
        end
      end
    end
  end

  describe 'season has more than one game'

  describe 'season has no games'
end
