require 'spec_helper'

describe "routes for badges" do
  it "routes /badges as badges_path" do
    { :get => "/badges" }.should route_to("badges#index")
    { :get => badges_path }.should route_to("badges#index")
  end

  it "routes /badges/:id as badge_path" do
    { :get => "/badges/1" }.should route_to(:controller => "badges", :action => "show", :id => "1")
    { :get => badge_path(1) }.should route_to(:controller => "badges", :action => "show", :id => "1")
  end
end

