require 'rspec/expectations'

RSpec::Matchers.define :require_login do
  match do |lambda|
    expect(lambda).to raise_error(QA::NotLoggedIn)
  end

  supports_block_expectations
end
