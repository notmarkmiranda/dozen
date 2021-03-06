FactoryBot.define do
  factory :player do
    game
    user
    finishing_place { 328 }
    score { 0.0 }
    additional_expense { 0 }
    sequence :finishing_order do |n| 
      n + 1
    end
  end

  after(:create) do |player, evaluator|
    if player.class == Player
      create :membership, league: player.game.season_league, user: player.user
    end
  end
end
