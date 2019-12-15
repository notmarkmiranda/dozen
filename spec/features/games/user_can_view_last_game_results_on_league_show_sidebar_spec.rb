require 'rails_helper'

describe 'admin can view last game results on league#show sidebar', type: :feature do
  let(:league) { create(:league, :public_league) }
  describe 'when there is a last game available' do
    let!(:first_game) { create(:game, completed: true, date: 2.days.ago, season: league.active_season).decorate }
    let(:last_game) { create(:game, completed: true, date: Date.today, season: league.active_season).decorate }
    let!(:winner) { create(:player, game: last_game, finishing_place: 1) }

    it 'shows last game results on sidebar' do
      visit league_path(league)

      expect(page).to have_content(league.name)

      within('.league-show__game-results') do
        expect(page).to have_content("Date / Time: #{last_game.full_date(last_game.date)}")
        expect(page).to have_content("Winner: #{last_game.winner_name}")
        expect(page).to have_content(last_game.pot_text)
        expect(page).to have_content(last_game.player_text)
      end
    end
  end

  pending 'when there is not last game available' do
    it 'shows no game available instead' do
      visit league_path(league)

      expect(page).to have_content(league.name)
      
      within('.league-show__game-results') do

      end
    end
  end
end
