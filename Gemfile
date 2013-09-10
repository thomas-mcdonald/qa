source 'https://rubygems.org'

gem 'rails', '4.0.0'

gem 'activerecord-import', '~> 0.4.1'
gem 'jquery-rails'
gem 'kaminari', '~> 0.14.1'
gem 'pg', '~> 0.15.0'
gem 'redcarpet', '~> 3.0.0'
gem 'redis', '~> 3.0.2'
gem 'redis-namespace', '~> 1.2.1'
gem 'ruby-progressbar'
gem 'seed-fu', github: 'mbleigh/seed-fu'
gem 'sidekiq', '~> 2.13.0'
gem 'simple_form', github: 'plataformatec/simple_form'

# Authentication
gem 'omniauth', '~> 1.1.0'
gem 'omniauth-openid', '1.0.1'

# Asset gems
gem 'bootstrap-sass', github: 'thomas-mcdonald/bootstrap-sass'
gem 'font-awesome-sass-rails'
gem 'sass-rails',   '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.0.3'

group :development do
  gem 'foreman'
  gem 'quiet_assets'
  # Guard for autorunning tests
  gem 'guard', '~> 1.8.0'
  gem 'guard-rspec', '~> 3.0.0'
  gem 'guard-spinach'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'terminal-notifier-guard'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.9'
  gem 'spinach-rails'
end

group :test do
  gem 'coveralls', require: false
  gem 'database_cleaner', '~> 1.0.0'
  gem 'factory_girl_rails', '~> 4.2.0'
  gem 'poltergeist', '~> 1.3.0'
  gem 'rspec', '~> 2.13'
  gem 'shoulda-matchers', '~> 1.5.0'
  gem 'spinach', '~> 0.8.3'
end