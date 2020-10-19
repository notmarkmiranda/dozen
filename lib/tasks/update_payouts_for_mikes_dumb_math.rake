desc "mike cassano's payout schedule doesn't comform to normal math"

task update_payouts_for_mikes_dumb_math: :environment do
  PAYOUT_SCHEDULE ||= {
    "75" => {
      "first" => "40",
      "second" => "25",
      "third" => "10"
    },
    "90" => {
      "first" => "45",
      "second" => "30",
      "third" => "15"
    },
    "105" => {
      "first" => "55",
      "second" => "30",
      "third" => "20"
    },
    "120" => {
      "first" => "60",
      "second" => "35",
      "third" => "25"
    },
    "135" => {
      "first" => "70",
      "second" => "40",
      "third" => "25"
    },
    "150" => {
      "first" => "75",
      "second" => "45",
      "third" => "30"
    },
    "165" => {
      "first" => "85",
      "second" => "50",
      "third" => "30"
    },
    "180" => {
      "first" => "90",
      "second" => "55",
      "third" => "35"
    },
    "210" => {
      "first" => "105",
      "second" => "65",
      "third" => "40"
    },
    "225" => {
      "first" => "115",
      "second" => "70",
      "third" => "40"
    },
  }.freeze
  
  league_id = ENV["league_id"]
  puts "You must include a league_id" unless league_id
  next unless league_id

  league = League.find(league_id)

  league.games.each do |game|
    schedule = PAYOUT_SCHEDULE[game.total_pot.to_s]

    first = game.players.find_by(finishing_place: 1)
    second = game.players.find_by(finishing_place: 2)
    third = game.players.find_by(finishing_place: 3)

    first.update(payout: schedule["first"].to_i)
    second.update(payout: schedule["second"].to_i)
    third.update(payout: schedule["third"].to_i)
  end
end