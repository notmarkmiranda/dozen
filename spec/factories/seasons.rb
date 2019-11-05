FactoryBot.define do
  factory :season do
    league { nil }
    active_season { false }
    completed { false }
  end
end
