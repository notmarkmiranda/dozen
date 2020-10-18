FactoryBot.define do
  factory :game do
    season
    league { nil }
    completed { false }
    buy_in { 100 }
    add_ons { false }
    address { "123 Fake St. Denver, CO 80000" }
    estimated_players_count { 25 }
    date { "2030-5-9 17:30:00" }
    payout_schedule { { "first" => "50", "second" => "30", "third" => "20" } }

    factory :game_with_players do
      transient do
        players_count { 5 }
      end

      after(:create) do |game, evaluator|
        evaluator.players_count.times do |n|
          create(:player, game: game, finishing_order: n)
        end
        
        GameCompleter.new(game, 'complete').save
      end
    end
  end
end
