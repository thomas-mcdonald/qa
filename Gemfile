source 'https://rubygems.org'

gem 'rails', '4.0.0.rc1'

gem 'activerecord-import', github: 'spectator/activerecord-import', branch: 'rails4' # fork for Rails 4 ~> 0.3.1
gem 'jquery-rails'
gem 'kaminari', '~> 0.14.1'
gem 'pg', '~> 0.15.0'
gem 'redcarpet', '~> 2.2.2'
gem 'redis', '~> 3.0.2'
gem 'redis-namespace', '~> 1.2.1'
gem 'simple_form', '~> 3.0.0.beta1'

# Authentication
gem 'omniauth', '~> 1.1.0'
gem 'omniauth-openid', '1.0.1'

# Asset gems. Could probably go in assets group
gem 'bootstrap-sass', '~> 2.3.1.0'
gem 'font-awesome-sass-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 4.0.0.beta1'
  gem 'coffee-rails', '~> 4.0.0.beta1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'foreman'
  # Guard for autorunning tests
  gem 'guard', '~> 1.7.0'
  gem 'guard-cucumber', '~> 1.4.0'
  gem 'guard-rspec', '~> 2.5.0'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'terminal-notifier-guard'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.9'
end

group :test do
  gem 'coveralls', require: false
  gem 'cucumber-rails', '1.3.0', require: false
  gem 'database_cleaner', github: 'bmabey/database_cleaner' # '~> 0.9.0'
  gem 'factory_girl_rails', '~> 4.2.0'
  gem 'poltergeist'
  gem 'shoulda-matchers', '~> 1.5.0'
end