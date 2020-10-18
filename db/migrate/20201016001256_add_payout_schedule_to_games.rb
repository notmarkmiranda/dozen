class AddPayoutScheduleToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :payout_schedule, :jsonb, null: false, default: {}
  end
end
