require 'rspec/expectations'

RSpec::Matchers.define :require_login do
  match do |lambda|
    lambda.should raise_error(QA::NotLoggedIn)
  end
end