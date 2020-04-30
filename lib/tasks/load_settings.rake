namespace :load_settings do
  desc 'Load settings for existing settable objects'
  task :league => :environment do
    League.all.each do |league|
      league.add_all_settings
      puts "League #{league.id}"
    end
  end

  task :season => :environment do
    Season.all.each do |season|
      season.add_all_settings
      puts "Season #{season.id}"
    end
  end

  task :all => [:league, :season]
end

desc "Load for everything"
task :load_settings => 'load_settings:all'