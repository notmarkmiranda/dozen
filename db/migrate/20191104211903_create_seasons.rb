class CreateSeasons < ActiveRecord::Migration[6.0]
  def change
    create_table :seasons, id: :uuid do |t|
      t.uuid :league_id
      t.boolean :active_season, default: true
      t.boolean :completed, default: false

      t.timestamps null: false
    end

    add_index :seasons, :league_id
  end
end
