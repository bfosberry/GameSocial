source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails', '4.1.11'

gem 'pg'
gem 'jquery-datetimepicker-rails'
gem 'ri_cal'

gem 'unicorn'
gem 'whenever'
gem 'syslog-logger'
gem 'debugger-ruby_core_source'

gem "wice_grid"
gem 'jquery-ui-rails'
gem 'rails3-jquery-autocomplete'
gem 'rails_12factor'
gem 'runtimeerror_notifier'

gem 'google_calendar', :git =>  'git://github.com/bfosberry/google_calendar.git', :branch => "support-service-accounts"

group :development, :test do
 gem 'sqlite3'
 gem 'binding_of_caller'
 gem 'better_errors'
end

group :development do
  gem 'capistrano-unicorn', :require => false
  # Use Capistrano for deployment
  gem 'capistrano', '2.15.3'
end

group :test do
  gem 'rspec-rails'
end

# Use SCSS for stylesheets
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'autoprefixer-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'
gem 'therubyracer'

#auth
gem 'omniauth-steam'
gem "omniauth-google-oauth2"

gem 'httparty'

gem 'steam-condenser', :git =>  'git://github.com/bfosberry/steam-condenser-ruby.git', :branch => "summaries"
gem 'sidekiq'
gem 'sinatra'
group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'


