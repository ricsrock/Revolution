source 'https://rubygems.org'

ruby "1.9.3"

gem 'rails', '~> 4.0.0'     #github: 'rails/rails'
gem 'arel',      github: 'rails/arel'
gem 'activerecord-deprecated_finders', github: 'rails/activerecord-deprecated_finders'

gem 'mysql', '2.9.1'#, :path => "vendor/gems/mysql-2.9.1"

# Gems used only for assets and not required
# in production environments by default.
gem 'sprockets-rails', github: 'rails/sprockets-rails'
gem 'sass-rails',   github: 'rails/sass-rails'
gem 'coffee-rails', github: 'rails/coffee-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'uglifier', '>= 1.0.3'
gem 'compass-rails', github: 'milgner/compass-rails', ref: '1749c06f15dc4b058427e7969810457213647fb8'
gem 'zurb-foundation', '3.2.5'
gem 'foundation-icons-sass-rails', github: 'zaiste/foundation-icons-sass-rails'

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'simple_form', github: 'plataformatec/simple_form'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

gem "acts_as_stampable", "~> 0.0.3"
gem 'ancestry'
gem "auto_strip_attributes"
gem 'awesome_nested_set'
gem 'cancan'
gem 'carrierwave'
gem 'chronic'
gem 'daemons'
gem 'delayed_job_active_record', '4.0.0.beta2'
gem "devise", github: "plataformatec/devise", branch: "rails4"
gem "devise-encryptable"
gem 'druthers'
gem "faker"
gem "figaro"
gem "fog", "~> 1.3.1"
#gem "font-awesome-rails", "~> 3.2.1.1"
gem 'geocoder'
gem 'git-deploy'
gem 'gmaps4rails', github: "fiedl/Google-Maps-for-Rails", ref: "6266f74a0ee02172f3f6a71d467340cbf9709995"
gem 'kaminari'
gem 'mailgun'
gem 'prawn'
gem 'prawn-print', :git => 'git://github.com/barsoom/prawn-print.git'
gem "ransack", :git => "https://github.com/ernie/ransack", :branch => 'rails-4'
# gem 'redis'
# gem 'resque', :require => "resque/server"
# gem 'resque-scheduler', :require => 'resque_scheduler'
gem 'rmagick', '2.13.2'#, :path => "vendor/gems/rmagick-2.13.2"
gem 'sidekiq'
gem 'tunnlr_connector', :require => "tunnlr"
# gem 'twilio-ruby', '~> 3.10.0'
gem 'twilio-rb'
gem 'vpim-rails'
gem "exception_notification", github: "smartinez87/exception_notification", branch: "master"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.0.1'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano', group: :development

# To use debugger
# gem 'debugger'

group :test, :development do
  gem "rspec-rails", "~> 2.0"
end

group :development do
  gem "better_errors"
  gem 'binding_of_caller'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'sqlite3'
end
