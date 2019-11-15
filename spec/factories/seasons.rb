FactoryBot.define do
  factory :season do
    league
    active_season { true }
    completed { false }
  end
end
