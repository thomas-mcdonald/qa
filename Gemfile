source 'http://rubygems.org'

gem 'rails', '3.2.1' 

gem 'activerecord-import'
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'bootstrap-sass', '2.0.1'
gem 'cancan', '1.6.7'
gem 'differ'
gem 'foreman'
gem 'jquery-rails', '1.0.17'
gem 'kaminari', '0.13.0'
gem 'nokogiri'
gem 'paper_trail', '2.2.4'
gem 'permanent_records', '2.1.2'
gem 'pjax_rails', '~> 0.1.7'
gem 'progressbar', '0.9.1'
gem 'redcarpet', '2.0.0b5'
gem 'resque', '1.19.0'

gem 'mysql2'
gem 'sqlite3'

group :assets do
  gem 'sass-rails', '~>3.2.0'
  gem 'coffee-rails', '~>3.2.0'
  gem 'uglifier'
end

group :development do
  gem 'guard', '0.9.4'
  gem 'guard-cucumber'
  gem 'guard-rspec'
  gem 'nifty-generators'
  gem 'rspec-rails'
  gem 'ruby_gntp'
end

group :test do
  gem 'cover_me', '>= 1.2.0'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'mocha'
  gem 'rspec'
  gem 'shoulda-matchers'
  gem 'webrat'
end

group :development, :test do
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'pickle'
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i  
end