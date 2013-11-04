# config/unicorn.rb
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 60
preload_app true

working_directory "/var/www/GameSocial/current/"
pid "/var/www/GameSocial/shared/pids/unicorn.pid"
listen "/var/www/GameSocial/shared/sockets/gamesocial.sock", :backlog => 64
listen 8080, :tcp_nopush => true

stderr_path "/var/www/GameSocial/current/log/unicorn.stderr.log"
stdout_path "/var/www/GameSocial/current/log/unicorn.stdout.log"

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end 

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
