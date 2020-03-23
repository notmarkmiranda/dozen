class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings, id: :uuid do |t|
      t.string :name
      t.string :value
      t.string :metric
      t.references :settable, polymorphic: true, type: :uuid, null: false, index: true

      t.timestamps
    end
  end
end
