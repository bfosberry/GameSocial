namespace :sync do
  desc "Synchronize users with steam"
  task :steam => :environment do
    User.all.each do |user|
      Workers::SyncWorker.perform_async(user.id)
    end
  end

  desc "Synchronize user locations with steam"
  task :location => :environment do
    User.all.each do |user|
      Workers::LocationSyncWorker.perform_async(user.id)
    end
  end

  desc "Synchronize all users"
  task :all => [:steam]
end

