FactoryBot.define do
  extensions = ["com", "net", "co", "email", "fr", "xyz"]
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence :email do |n|
      "#{first_name}_U#{last_name}#{rand(100..999)}@#{last_name}#{rand(100..999)}.#{extensions.shuffle.pop}"
    end
    password { "password" }
  end
end
