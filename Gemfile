source 'https://rubygems.org'

ruby "1.9.3"

gem 'rails', '= 4.0.0.beta1'     #github: 'rails/rails'
gem 'arel',      github: 'rails/arel'
gem 'activerecord-deprecated_finders', github: 'rails/activerecord-deprecated_finders'

gem 'mysql'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sprockets-rails', github: 'rails/sprockets-rails'
  gem 'sass-rails',   github: 'rails/sass-rails'
  gem 'coffee-rails', github: 'rails/coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', platforms: :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails', github: 'milgner/compass-rails', ref: '1749c06f15dc4b058427e7969810457213647fb8'
  gem 'zurb-foundation', '3.2.5'
  gem 'foundation-icons-sass-rails'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'simple_form', github: 'plataformatec/simple_form'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

gem "font-awesome-rails"
gem 'awesome_nested_set'
gem 'kaminari'
gem 'chronic'
gem 'carrierwave'
gem 'rmagick', '2.13.2'
gem 'git-deploy'
gem "fog", "~> 1.3.1"
gem "faker"
gem "devise"

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

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'sqlite3'
end
