class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.references :season, null: true, foreign_key: true
      t.references :league, null: true, foreign_key: true
      t.boolean :completed, default: false
      t.integer :buy_in
      t.boolean :add_ons
      t.string :address
      t.integer :players
      t.datetime :date

      t.timestamps null: false
    end
  end
end
