class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.string :name
      t.string :value
      t.string :metric
      t.references :settable, polymorphic: true, null: false, index: true

      t.timestamps
    end
  end
end
