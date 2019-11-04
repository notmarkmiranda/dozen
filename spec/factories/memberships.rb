FactoryBot.define do
  factory :membership do
    user
    league
    role { 1 }
  end
end
