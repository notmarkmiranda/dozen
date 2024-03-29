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
        expect(page).to have_content("Date / Time: #{last_game.formatted_full_date}")
        expect(page).to have_content("Winner: #{last_game.winner_name}")
        expect(page).to have_content("Pot Size: #{last_game.send(:actual_pot)}")
        expect(page).to have_content("# of Players: #{last_game.players_count}")
      end
    end
  end

  describe 'when there is not last game available' do
    it 'shows no game available instead' do
      visit league_path(league)

      expect(page).to have_content(league.name)

      within('.league-show__game-results') do
        expect(page).to have_content('No prior game results, check back later.')
      end
    end
  end
end
