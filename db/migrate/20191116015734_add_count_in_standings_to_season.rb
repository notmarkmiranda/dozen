class AddCountInStandingsToSeason < ActiveRecord::Migration[6.0]
  def change
    add_column :seasons, :count_in_standings, :boolean, default: true
  end
end
