class ChangeColumnDefaultForFinishingOrderOnPlayer < ActiveRecord::Migration[6.0]
  def change
    change_column_default :players, :finishing_order, nil
  end
end
