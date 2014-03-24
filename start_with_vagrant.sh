#!/bin/bash

vagrant up
#install ruby version for the app
vagrant ssh -c "rvm install 1.9.3-p385"
#install problem gem and then all other gems in the gemfile
vagrant ssh -c "cd /vagrant && gem install debugger-ruby_core_source && bundle install"
#set up the db
vagrant ssh -c "cd /vagrant && rake db:create && rake db:migrate && rake db:seed"
#restart the web server and write the crontab
vagrant ssh -c "cat /vagrant/tmp/pids/server.pid | xargs kill -9"
vagrant ssh -c "cd /vagrant && rails s -d -P /vagrant/tmp/pids/server.pid  && bundle exec whenever -w --set 'environment=development'"
#restart sidekiq
vagrant ssh -c "cd /vagrant && sidekiqctl stop /vagrant/tmp/pids/sidekiq.pid"
vagrant ssh -c "cd /vagrant && sidekiq -C /vagrant/config/sidekiq.yml -P /vagrant/tmp/pids/sidekiq.pid -L /vagrant/log/sidekiq.log -d"
