FactoryBot.define do
  factory :game do
    season
    league { nil }
    completed { false }
    buy_in { 100 }
    add_ons { false }
    address { "123 Fake St. Denver, CO 80000" }
    players { 25 }
    date { "2030-5-9 17:30:00" }
  end
end
