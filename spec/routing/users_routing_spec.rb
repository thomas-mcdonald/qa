require 'spec_helper'

describe "routing to users" do
  it "routes /signup to users#new" do
    { get: "/signup" }.should route_to(controller: "users", action: "new")
  end

  it "routes authorisation callbacks to users#confirm" do
    { get: '/auth/google/callback' }.should route_to(controller: 'authorizations', action: 'callback', provider: 'google')
    { post: '/auth/google/callback' }.should route_to(controller: 'authorizations', action: 'callback', provider: 'google')
  end
end