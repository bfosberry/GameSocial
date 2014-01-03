require 'sidekiq/capistrano'
require 'capistrano-unicorn'
require 'bundler/capistrano'
require 'whenever/capistrano'

set :application, "GameSocial"
set :repository,  "https://github.com/bfosberry/GameSocial.git"
set :deploy_to, "/var/www/GameSocial"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "cloud1001.co"                          # Your HTTP server, Apache/etc
role :app, "cloud1001.co"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

set :scm, "git"
set :user, "rails"
set :use_sudo, false
set :normalize_asset_timestamps, false
set :branch, fetch(:branch, "master")

after 'deploy:restart', 'unicorn:duplicate'
after 'deploy:update_code', 'deploy:symlink_db'
after 'deploy:update_code', 'deploy:symlink_secrets'

namespace :deploy do
  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end
  task :symlink_secrets, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/secret.yml #{release_path}/config/secret.yml"
  end
end

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
