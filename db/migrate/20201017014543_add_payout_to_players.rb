class AddPayoutToPlayers < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :payout, :float, default: 0.0
  end
end
