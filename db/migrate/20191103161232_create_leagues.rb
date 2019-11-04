class CreateLeagues < ActiveRecord::Migration[6.0]
  def change
    create_table :leagues do |t|
      t.string :name
      t.string :location
      t.boolean :public_league, default: false

      t.timestamps null: false
    end
  end
end
