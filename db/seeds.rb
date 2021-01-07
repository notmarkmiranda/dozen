Game.destroy_all
Season.destroy_all
League.destroy_all
Membership.destroy_all
User.destroy_all
puts "##### YOLO! #####"

admin_user = User.find_or_create_by(first_name: "Mark", last_name: "Miranda", email: "notmarkmiranda@gmail.com")
admin_user.password = "password"
admin_user.save

league = League.find_or_create_by(name: "Super Duper")
league.location = "Zoom"
league.public_league = true
league.save

user_count = User.count
users = user_count == 11 ? User.all : FactoryBot.create_list(:user, 11 - user_count)

admin_membership = Membership.find_or_create_by(user: admin_user, league: league, role: 1)

puts "##### USERS #####"

memberships = users.map do |user|
  membership = Membership.find_or_initialize_by(user: user, league: league)
  membership.role = 0 if membership.new_record?
  membership.save
  puts "#{user.email} added to #{league.name} league."
end

season = league.seasons.last

dates = [*1..12].map do |n|
  Date.new(2020, n, n)
end

games = dates.map do |date|
  season.games.create!(
    completed: false,
    buy_in: rand(15..150),
    add_ons: true,
    address: "123 Fake Street, Anyplace, Colorado",
    estimated_players_count: rand(2..50),
    date: date,
    payout_schedule: { "first" => "50", "second" => "30", "third" => "20" }
  )
end

puts "##### GAMES ######"
games.each do |game|
  u_array = league.memberships.map(&:user).shuffle.shuffle
  u_array.each_with_index do |user, i|
    game.players.create!(finishing_order: (i + 1), user: user, additional_expense: [0, game.buy_in, game.buy_in * 2].sample)
  end
  GameCompleter.new(game, 'complete').save
  puts "Game on #{game.decorate.formatted_short_month_full_date} completed."
end

season.update(completed: true)
puts "##### DONE! #####"