namespace :sync do
  desc "Synchronize users with steam"
  task :steam => :environment do
    puts "Syncing users..."
    User.all.each do |user|
      puts "Syncing #{user.name}"
      w = Workers::SyncWorker.new
      w.perform(user.id)
    end
  end

  desc "Synchronize all users"
  task :all => [:steam]
end
