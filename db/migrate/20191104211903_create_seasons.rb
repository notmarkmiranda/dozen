class CreateSeasons < ActiveRecord::Migration[6.0]
  def change
    create_table :seasons do |t|
      t.references :league, null: false, foreign_key: true
      t.boolean :active_season, default: true
      t.boolean :completed, default: false

      t.timestamps null: false
    end
  end
end
