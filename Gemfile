source 'https://rubygems.org'

gem 'rails', '4.0.0.beta1'

gem 'jquery-rails'
gem 'redcarpet', '~> 2.2.2'
gem 'simple_form', '~> 3.0.0.beta1'
gem 'sqlite3'

# Authentication
gem 'omniauth', '~> 1.1.0'
gem 'omniauth-openid', '1.0.1'

# Asset gems. Could probably go in assets group
gem 'bootstrap-sass', '~> 2.3.0.0'
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
  gem 'guard', '~> 1.6.2'
  gem 'guard-cucumber', '~> 1.3.2'
  gem 'guard-rspec', '~> 2.5.0'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'terminal-notifier-guard'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.9'
end

group :test do
  gem 'cucumber-rails', '1.3.0', require: false
  gem 'database_cleaner', github: 'bmabey/database_cleaner' # '~> 0.9.0', 
  gem 'factory_girl_rails', '~> 4.2.0'
  gem 'shoulda-matchers', '~> 1.4.0'
end

# require last. lol.
gem 'rack-mini-profiler', git: 'git://github.com/SamSaffron/MiniProfiler'