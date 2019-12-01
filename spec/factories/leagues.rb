FactoryBot.define do
  factory :league do
    name { Faker::Team.name }
    location { Faker::Address.city }
    public_league { false }
  end
end
