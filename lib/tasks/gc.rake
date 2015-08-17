namespace :gc do
  desc "Clean up old alerts"
  task :alerts => :environment do
    alerts = Alert.where("created_at < :month_ago", {:month_ago => 1.month.ago})
    puts "Deleting #{alerts.size} alerts"
    alerts.each(&:destroy)
    puts "Done"
  end

  desc "Clean up old game locations"
  task :locations => :environment do
    
    locations = GameLocation.where("created_at < :month_ago", {:month_ago => 1.month.ago})
    puts "Deleting #{locations.size} locations"
    locations.each(&:destroy)
    puts "Done"
  end
end

