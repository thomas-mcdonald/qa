if ENV['CI']
  require 'coveralls'
  Coveralls.wear_merged!('rails')
end

ENV['RAILS_ENV'] = 'test'
require './config/environment'

require 'rspec/expectations'
require 'mocha/setup'

# Require all shared step files
Dir["#{Rails.root}/features/steps/shared/*.rb"].each {|file| require file}

# Setup Javascript tags
require 'capybara/poltergeist'
Capybara.default_driver = :poltergeist
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
OmniAuth.config.mock_auth[:google] = omniauth_hash

# DBCleaner
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

Spinach.hooks.before_scenario { DatabaseCleaner.clean }
Spinach.hooks.after_scenario do
  Mocha::Mockery.teardown
  OmniAuth.config.mock_auth[:google] = omniauth_hash # reset any admin trickery
end

# factorygirl niceness
Spinach.hooks.before_run do
  include FactoryGirl::Syntax::Methods
end

class Spinach::FeatureSteps
  attr_accessor :assertions

  def initialize
    super
    @assertions = 0
  end
end
