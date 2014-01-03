namespace :sync do
  desc "Synchronize users with steam"
  task :steam => :environment do
    User.all.each do |user|
      Workers::SyncWorker.perform_async(user.id)
    end
  end

  desc "Synchronize all users"
  task :all => [:steam]
end
