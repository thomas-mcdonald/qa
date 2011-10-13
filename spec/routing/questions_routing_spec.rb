require 'spec_helper'

describe "routes for Questions" do
  it "routes /questions as questions_path" do
    { :get => "/questions" }.should route_to("questions#index")
    { :get => questions_path }.should route_to("questions#index")
  end

  it "routes /questions/:id as question_path" do
    { :get => "/questions/1" }.should route_to(:controller => "questions", :action => "show", :id => "1")
    { :get => question_path(1) }.should route_to(:controller => "questions", :action => "show", :id => "1") 
  end

  it "routes /questions/new as new_question_path" do
    { :get => "/questions/new" }.should route_to("questions#new")
    { :get => new_question_path }.should route_to("questions#new")
  end

  it "routes post on /questions" do
    { :post => "/questions" }.should route_to("questions#create")
  end

  it "routes /questions/:id/edit as edit_question_path" do
    { :get => "/questions/1/edit" }.should route_to(:controller => "questions", :action => "edit", :id => "1")
    { :get => edit_question_path(1) }.should route_to(:controller => "questions", :action => "edit", :id => "1")
  end

  it "routes put on /questions/:id" do
    { :put => "/questions/1" }.should route_to(:controller => "questions", :action => "update", :id => "1")
  end

  it "routes delete on /questions" do
    { :delete => "/questions/1" }.should route_to(:controller => "questions", :action => "destroy", :id => "1")
  end

  it "routes post on /questions/:id/restore as restore_question_path" do
    { :post => "/questions/1/restore" }.should route_to(:controller => "questions", :action => "restore", :id => "1")
    { :post => restore_question_path(1) }.should route_to(:controller => "questions", :action => "restore", :id => "1") 
  end

  it "routes /questions/:id/revisions as revisions_question_path" do
    { :get => "/questions/1/revisions" }.should route_to(:controller => "questions", :action => "revisions", :id => "1")
    { :get => revisions_question_path(1) }.should route_to(:controller => "questions", :action => "revisions", :id => "1")
  end

  it "routes /questions/tagged/:tag as tagged_questions_path" do
    { :get => "/questions/tagged/test" }.should route_to(:controller => "questions", :action => "tagged", :tag => "test")
    { :get => tagged_questions_path("test") }.should route_to(:controller => "questions", :action => "tagged", :tag => "test")
  end
end

