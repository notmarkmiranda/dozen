class AddScoringSystemToSeasons < ActiveRecord::Migration[6.0]
  def change
    add_column :seasons, :scoring_system, :integer, default: 0
  end
end
