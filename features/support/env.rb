ENV['RAILS_ENV'] = 'test'
require './config/environment'

require 'rspec'

# Require all shared step files
Dir["#{Rails.root}/features/steps/shared/*.rb"].each {|file| require file}

# Setup Javascript tags
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Spinach.hooks.on_tag("javascript") do
  ::Capybara.current_driver = ::Capybara.javascript_driver
end
Capybara.default_wait_time = 10

# Setup Omniauth mock
def omniauth_hash
  {
    info: {
      email: 'example@google.com',
      name: 'John Doe'
    },
    provider: 'google',
    uid: 'https://www.google.com/accounts/o8/id?id=fakeuid'
  }
end
OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(:google, omniauth_hash)

# DBCleaner
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

Spinach.hooks.before_scenario { DatabaseCleaner.clean }

# factorygirl niceness
Spinach.hooks.before_run do
  include FactoryGirl::Syntax::Methods
end