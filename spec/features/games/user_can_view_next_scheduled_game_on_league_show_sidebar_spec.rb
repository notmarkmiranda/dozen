require 'rails_helper'

describe 'user can view next scheduled game on league show sidebar' do
  let(:league) { create(:league, :public_league) }

  describe 'when a game is scheduled' do
    let!(:game) { create(:game, completed: false, date: Time.zone.now, season: league.active_season).decorate }

    it 'displays text for next scheduled game' do
      visit league_path(league)

      expect(page).to have_content(league.name)

      within('.league-show__next-scheduled-game-main') do
        expect(page).to have_content(game.formatted_full_date)
        expect(page).to have_content(game.buy_in_text)
        expect(page).to have_content(game.player_text)
        expect(page).to have_content(game.pot_text)
      end
    end
  end

  describe 'when a game is not scheduled'
end
