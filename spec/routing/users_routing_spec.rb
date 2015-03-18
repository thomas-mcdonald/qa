require 'spec_helper'

describe "routing to users", :type => :routing do
  it "routes authorisation callbacks to users#confirm" do
    expect({ get: '/auth/google/callback' }).to route_to(controller: 'authorizations', action: 'callback', provider: 'google')
    expect({ post: '/auth/google/callback' }).to route_to(controller: 'authorizations', action: 'callback', provider: 'google')
  end
end
