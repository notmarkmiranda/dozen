class AddFinishingOrderToPlayer < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :finishing_order, :integer, default: 1
  end
end
