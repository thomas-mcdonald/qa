# Setup poltergeist
require 'capybara/poltergeist'
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, inspector: true)
end
Capybara.javascript_driver = :poltergeist