require 'spec_helper'

describe "routing to users" do
  it "routes /signup to users#new" do
    { get: "/signup" }.should route_to(controller: "users", action: "new")
  end
end