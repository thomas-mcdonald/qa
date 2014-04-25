source 'https://rubygems.org'

gem 'rails', '4.1.0'

gem 'activerecord-import', '~> 0.5.0'
gem 'jquery-rails'
gem 'kaminari', '~> 0.15.0'
gem 'pg', '~> 0.17.0'
gem 'pundit', '~> 0.2.1'
gem 'redcarpet', '~> 3.1.0'
gem 'redis', '~> 3.0.4'
gem 'redis-namespace', '~> 1.4.1'
gem 'ruby-progressbar'
gem 'seed-fu', '~> 2.3.1'
gem 'settingslogic', '~> 2.0.9'
gem 'simple_form', '~> 3.0.2'

# Authentication
gem 'omniauth', '~> 1.2.0'
gem 'omniauth-openid', '1.0.1'

# Jobs & web interface
gem 'sidekiq', '~> 3.0.0'
gem 'sinatra'

# Asset gems
gem 'bootstrap-sass', '~> 3.1.1'
gem 'font-awesome-sass-rails'
gem 'sass-rails',   '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.0.3'

group :development do
  gem 'foreman'
  gem 'quiet_assets'
  # Guard for autorunning tests
  gem 'guard', '~> 2.6.0'
  gem 'guard-rspec', '~> 4.2.0'
  gem 'guard-spinach', github: 'thomas-mcdonald/guard-spinach'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'spring'
  gem 'terminal-notifier-guard'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.14'
  gem 'spinach-rails'
end

group :test do
  gem 'minitest'
  gem 'coveralls', require: false
  gem 'database_cleaner', '~> 1.2.0'
  gem 'factory_girl_rails', '~> 4.4.1'
  gem 'mocha', '~> 1.0.0', require: false
  gem 'poltergeist', '~> 1.5.0'
  gem 'rspec', '~> 2.13'
  gem 'shoulda-matchers', '~> 2.6.0', require: false
  gem 'spinach', '~> 0.8.3'
end
