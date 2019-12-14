class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games, id: :uuid do |t|
      t.uuid :season_id
      t.uuid :league_id
      t.boolean :completed, default: false
      t.integer :buy_in
      t.boolean :add_ons
      t.string :address
      t.integer :players
      t.datetime :date

      t.timestamps null: false
    end

    add_index :games, :league_id
    add_index :games, :season_id
  end
end
