require 'rails_helper'

describe 'user can view next scheduled game on league show sidebar', type: :feature do
  let(:league) { create(:league, :public_league) }

  describe 'when a game is scheduled' do
    let!(:game) { create(:game, completed: false, date: Time.zone.now, season: league.active_season).decorate }

    it 'displays text for next scheduled game' do
      visit league_path(league)

      expect(page).to have_content(league.name)

      within('.league-show__next-scheduled-game-main') do
        expect(page).to have_content(game.formatted_full_date)
        expect(page).to have_content(game.buy_in_text)
        expect(page).to have_content("Estimated Players: #{game.estimated_players_count}")
        expect(page).to have_content("Estimated Pot: #{game.send(:estimated_pot)}")
      end
    end
  end

  describe 'when a game is not scheduled' do
    it 'displays text that says there is no scheduled game' do
      visit league_path(league)

      expect(page).to have_content(league.name)

      within('.league-show__next-scheduled-game-main') do
        expect(page).to have_content('There is no game scheduled yet, check back later.')
      end
    end
  end
end
