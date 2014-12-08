source 'https://rubygems.org'

gem 'rails', '4.1.8'

gem 'dalli', '~> 2.7.2'
gem 'faker', '~> 1.4.2'
gem 'html-pipeline', '~> 1.9.0'
gem 'kaminari', '~> 0.16.0'
gem 'pg', '~> 0.17.0'
gem 'pundit', '~> 0.3.0'
gem 'redcarpet', '~> 3.2.0'
gem 'redis', '~> 3.1.0'
gem 'redis-namespace', '~> 1.5.0'
gem 'ruby-progressbar'
gem 'sanitize', '~> 3.0.0'
gem 'seedbank', '~> 0.3.0'
gem 'settingslogic', '~> 2.0.9'
gem 'simple_form', '~> 3.1.0'

# Authentication
gem 'omniauth', '~> 1.2.0'
gem 'omniauth-openid', '1.0.1'

# Jobs & web interface
gem 'sidekiq', '~> 3.3.0'
gem 'sinatra', require: false

# Asset gems
gem 'bootstrap-sass', '~> 3.2.0'
gem 'font-awesome-sass-rails'
gem 'jquery-rails', '~> 3.1.2'
gem 'sass-rails',   '~> 4.0.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'uglifier', '>= 1.0.3'

group :development do
  gem 'quiet_assets'
  # Guard for autorunning tests
  gem 'guard', '~> 2.6.0'
  gem 'guard-rspec', '~> 4.3.0'
  gem 'guard-spinach', github: 'thomas-mcdonald/guard-spinach'
  gem 'rails-erd', github: 'paulwittmann/rails-erd', branch: 'mavericks'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'spring'
  gem 'terminal-notifier-guard'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'spinach-rails'
end

group :test do
  gem 'minitest'
  gem 'coveralls', require: false
  gem 'database_cleaner', '~> 1.3.0'
  gem 'factory_girl_rails', '~> 4.4.1'
  gem 'mocha', '~> 1.0.0', require: false
  gem 'poltergeist', '~> 1.5.0'
  gem 'rspec', '~> 3.0'
  gem 'shoulda-matchers', '~> 2.6.0', require: false
  gem 'spinach', '~> 0.8.3'
end
