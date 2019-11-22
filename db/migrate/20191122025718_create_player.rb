class CreatePlayer < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.references :game, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :finishing_place
      t.float :score, default: 0.00
      t.integer :additional_expense, default: 0
      t.datetime :finished_at

      t.timestamps null: false
    end
  end
end
