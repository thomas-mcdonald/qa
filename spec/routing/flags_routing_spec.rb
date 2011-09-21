require 'spec_helper'

describe "routes for flags" do
  # Flag nested routes
  it "routes /questions/:question_id/flags/new as new_question_flag_path" do
    { :get => "/questions/1/flags/new" }.should route_to(:controller => "flags", :action => "new", :question_id => "1")
    { :get => new_question_flag_path(1) }.should route_to(:controller => "flags", :action => "new", :question_id => "1")
  end

  it "routes post on /questions/:question_id/flags as question_flags_path" do
    { :post => "/questions/1/flags" }.should route_to(:controller => "flags", :action => "create", :question_id => "1")
    { :post => question_flags_path(1) }.should route_to(:controller => "flags", :action => "create", :question_id => "1")
  end

  it "routes /answers/:answer_id/flags/new as new_answer_flag_path" do
    { :get => "/answers/1/flags/new" }.should route_to(:controller => "flags", :action => "new", :answer_id => "1")
    { :get => new_answer_flag_path(1) }.should route_to(:controller => "flags", :action => "new", :answer_id => "1")
  end

  it "routes post on /answers/:answer_id/flags as answer_flags_path" do
    { :post => "/answers/1/flags" }.should route_to(:controller => "flags", :action => "create", :answer_id => "1")
    { :post => answer_flags_path(1) }.should route_to(:controller => "flags", :action => "create", :answer_id => "1")
  end
  
  # Non-nested routes
  it "routes /flags as flags_path" do
    { :get => "/flags" }.should route_to("flags#index")
    { :get => flags_path }.should route_to("flags#index")
  end

  it "routes /flags/:id/dismiss as dismiss_flag_path" do
    { :get => "/flags/1/dismiss" }.should route_to(:controller => "flags", :action => "dismiss", :id => "1")
    { :get => dismiss_flag_path(1) }.should route_to(:controller => "flags", :action => "dismiss", :id => "1")
  end
end

