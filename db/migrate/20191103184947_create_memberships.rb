class CreateMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :memberships, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :league_id
      t.integer :role, default: 0

      t.timestamps null: false
    end

    add_index :memberships, :league_id
    add_index :memberships, :user_id
  end
end
