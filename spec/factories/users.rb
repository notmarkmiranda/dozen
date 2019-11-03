FactoryBot.define do
  factory :user do
    first_name { "Mark" }
    last_name { "Miranda" }
    sequence :email do |n| 
      "test#{n}@example.com"
    end
    password { "password" }
  end
end