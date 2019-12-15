FactoryBot.define do
  factory :league do
    name { Faker::Team.name }
    location { Faker::Address.city }

    trait :public_league do
      public_league { true }
    end

    trait :private_league do
      public_league { false }
    end
  end
end
