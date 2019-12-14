class CreatePlayer < ActiveRecord::Migration[6.0]
  def change
    create_table :players, id: :uuid do |t|
      t.uuid :game_id
      t.uuid :user_id
      t.integer :finishing_place
      t.float :score, default: 0.00
      t.integer :additional_expense, default: 0
      t.datetime :finished_at

      t.timestamps null: false
    end

    add_index :players, :game_id
    add_index :players, :user_id
  end
end
